import json
from uuid import uuid4
from datetime import datetime, timezone
from fastapi import APIRouter, Depends, File, UploadFile, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from app.core.database import get_db
from app.core.security import verify_firebase_token
from app.models.db_models import Product, ScanHistory, User
from app.services.vision_service import analyze_product_image
from app.services.off_service import search_off_by_name
from app.services.intelligence_engine import analyze_product
from app.services.dietary_validator import validate_diet
from app.schemas.pydantic_schemas import ScanResponse

router = APIRouter(prefix="/scan", tags=["Scanning"])

@router.post("", response_model=ScanResponse)
async def scan_product(
    image: UploadFile = File(...),
    db: AsyncSession = Depends(get_db),
    uid: str = Depends(verify_firebase_token)
):
    """
    Hybrid Scan Workflow:
    1. Gemini 1.5 Flash parses image (name, ingredients, nutrients)
    2. Check Cache
    3. Fallback to Open Food Facts if nutrients unavailable
    4. Run ML Engine & Dietary Validator
    5. Cache & Return
    """
    # 0. Get the current user
    user_stmt = select(User).where(User.firebase_uid == uid)
    user_res = await db.execute(user_stmt)
    user = user_res.scalars().first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found in DB")

    # 1. Vision parsing
    image_bytes = await image.read()
    vision_data = await analyze_product_image(image_bytes, image.content_type or "image/jpeg")
    
    if not vision_data or not vision_data.get("product_name"):
        raise HTTPException(status_code=400, detail="Could not detect a food product in the image.")
        
    p_name = vision_data["product_name"]
    p_brand = vision_data["brand"]
    p_category = vision_data["food_category"]
    
    # 2. Check SQLite Cache
    # We'll do a simple ILIKE search for now
    cache_stmt = select(Product).where(
        Product.name.ilike(f"%{p_name}%")
    ).limit(1)
    cache_res = await db.execute(cache_stmt)
    cached_product = cache_res.scalars().first()
    
    if cached_product:
        # Save to history
        hist = ScanHistory(
            id=str(uuid4()),
            user_id=user.id,
            product_id=cached_product.id,
            scanned_at=datetime.now(timezone.utc)
        )
        db.add(hist)
        await db.commit()
        
        # Healthy Swap Logic
        swaps = []
        if cached_product.final_score < 5.0:
            swap_stmt = select(Product).where(
                Product.category == cached_product.category,
                Product.final_score >= 7.0
            ).limit(3)
            swap_res = await db.execute(swap_stmt)
            swaps = swap_res.scalars().all()
            
        return {
            "status": "success", 
            "source": "cache", 
            "data": {**cached_product.__dict__, "healthy_swaps": [s.__dict__ for s in swaps]}
        }
        
    # 3. Compile features
    macros = {}
    ingredients = vision_data["ingredients_text"]
    nova_group = 0
    allergens = []
    
    if vision_data["is_nutrition_visible"]:
        macros = vision_data["nutrients"]
    else:
        off_data = await search_off_by_name(p_name, p_brand)
        if off_data:
            macros = off_data
            nova_group = off_data["nova_group"]
            allergens = off_data["allergens_tags"]
            if not ingredients:
                ingredients = off_data["ingredients_text"]
        else:
            raise HTTPException(status_code=404, detail="Nutrition not visible and no OFF fallback found.")

    # 4. Intelligence Engine & Validator
    analysis = analyze_product({
        "energy_kcal": macros.get("energy_kcal", macros.get("calories_100g", 0)),
        "sugars": macros.get("sugars", 0),
        "sat_fat": macros.get("sat_fat", 0),
        "sodium": macros.get("sodium", 0),
        "fiber": macros.get("fiber", 0),
        "protein": macros.get("protein", 0),
        "nova_group": nova_group
    })
    
    validation = validate_diet(
        ocr_ingredients=ingredients,
        off_allergens=allergens,
        user_focus=user.dietary_focus,
        sugar_g=macros.get("sugars", 0)
    )
    
    # 5. Save to Cache
    new_product = Product(
        id=str(uuid4()),
        name=p_name,
        brand=p_brand,
        category=p_category,
        image_url="", # Can be updated later if uploaded to GCS
        off_data_json=json.dumps(macros),
        ocr_ingredients_text=ingredients,
        hidden_additives_json=json.dumps(validation["hidden_additives"]),
        allergens_json=json.dumps(allergens),
        final_score=analysis["final_score"],
        health_category=analysis["health_category"],
        insights_json=json.dumps(analysis["insights"]),
        sugar_rda_pct=analysis["sugar_rda_pct"],
        sodium_rda_pct=analysis["sodium_rda_pct"],
        nova_group=nova_group,
        is_veg=validation["is_veg"],
        last_fetched_at=datetime.now(timezone.utc)
    )
    
    db.add(new_product)
    
    hist = ScanHistory(
        id=str(uuid4()),
        user_id=user.id,
        product_id=new_product.id,
        dietary_conflict=validation["dietary_conflict"],
        scanned_at=datetime.now(timezone.utc)
    )
    db.add(hist)
    
    await db.commit()
    await db.refresh(new_product)
    
    # Healthy Swap Logic for newly scanned items
    swaps = []
    if new_product.final_score < 5.0:
        swap_stmt = select(Product).where(
            Product.category == p_category,
            Product.final_score >= 7.0
        ).limit(3)
        swap_res = await db.execute(swap_stmt)
        swaps = swap_res.scalars().all()
    
    # Merge context for response
    response_data = {
        **new_product.__dict__,
        "dietary_validation": validation,
        "healthy_swaps": [s.__dict__ for s in swaps]
    }
    response_data.pop("_sa_instance_state", None)
    
    return {"status": "success", "source": "processed", "data": response_data}
