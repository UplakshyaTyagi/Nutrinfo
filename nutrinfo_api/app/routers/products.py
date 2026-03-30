"""Product search and detail endpoints — no auth required."""
from fastapi import APIRouter, Query
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import Depends

from app.core.database import get_db
from app.models.db_models import Product

router = APIRouter(prefix="/products")


def _health_category(score: float) -> str:
    if score >= 8.5:
        return "Super Healthy"
    elif score >= 6.5:
        return "Healthy"
    elif score >= 4.5:
        return "Eatable"
    elif score >= 2.5:
        return "Unhealthy"
    else:
        return "Super Unhealthy"


def _product_to_dict(p: Product) -> dict:
    score = p.health_score or 5.0
    return {
        "id": p.id,
        "product_name": p.product_name,
        "sugars_100g": p.sugars_100g,
        "sat_fat_100g": p.sat_fat_100g,
        "sodium_mg_100g": p.sodium_mg_100g,
        "fiber_100g": p.fiber_100g,
        "protein_100g": p.protein_100g,
        "calories_100g": p.calories_100g,
        "nova_group": p.nova_group,
        "additives_n": p.additives_n,
        "health_score": score,
        "health_category": _health_category(score),
    }


@router.get("/search")
async def search_products(
    q: str = Query(..., min_length=2, description="Search query for product name"),
    limit: int = Query(20, ge=1, le=50),
    db: AsyncSession = Depends(get_db),
):
    """Fuzzy search products by name. Returns up to `limit` results."""
    query = q.strip().lower()
    stmt = (
        select(Product)
        .where(func.lower(Product.product_name).contains(query))
        .limit(limit)
    )
    result = await db.execute(stmt)
    products = result.scalars().all()
    return [_product_to_dict(p) for p in products]


@router.get("/{product_id}")
async def get_product(
    product_id: int,
    db: AsyncSession = Depends(get_db),
):
    """Get a single product by numeric ID."""
    stmt = select(Product).where(Product.id == product_id)
    result = await db.execute(stmt)
    product = result.scalar_one_or_none()
    if product is None:
        return {"error": "Product not found", "detail": f"No product with id={product_id}"}
    return _product_to_dict(product)


@router.post("/scan-by-name")
async def scan_by_name(
    body: dict,
    db: AsyncSession = Depends(get_db),
):
    """
    Search for a product by OCR-extracted name.
    Expects: {"product_name": "some text from the label"}
    Returns the best match or a not-found message.
    """
    raw_name = (body.get("product_name") or "").strip()
    if not raw_name or len(raw_name) < 2:
        return {"found": False, "message": "Product nutrition info has not been updated yet."}

    # Try exact-ish match first (case-insensitive contains)
    query = raw_name.lower()
    stmt = (
        select(Product)
        .where(func.lower(Product.product_name).contains(query))
        .limit(5)
    )
    result = await db.execute(stmt)
    products = result.scalars().all()

    if products:
        return {
            "found": True,
            "products": [_product_to_dict(p) for p in products],
        }

    # Try word-by-word matching (split query into words, match any)
    words = [w for w in query.split() if len(w) > 2]
    if words:
        # Match products containing any of the significant words
        for word in words[:3]:  # Limit to first 3 words
            stmt = (
                select(Product)
                .where(func.lower(Product.product_name).contains(word))
                .limit(5)
            )
            result = await db.execute(stmt)
            products = result.scalars().all()
            if products:
                return {
                    "found": True,
                    "products": [_product_to_dict(p) for p in products],
                }

    return {"found": False, "message": "Product nutrition info has not been updated yet."}
