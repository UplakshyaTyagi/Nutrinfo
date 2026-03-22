import json
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from app.core.database import get_db
from app.core.security import verify_firebase_token
from app.models.db_models import Product
from app.schemas.pydantic_schemas import ProductResponse

router = APIRouter(prefix="/products", tags=["Products"])

@router.get("/{product_id}", response_model=ProductResponse)
async def get_product(
    product_id: str,
    db: AsyncSession = Depends(get_db),
    uid: str = Depends(verify_firebase_token)
):
    """Fetch a scanned product from the cache by its UUID."""
    stmt = select(Product).where(Product.id == product_id)
    res = await db.execute(stmt)
    product = res.scalars().first()
    
    if not product:
        raise HTTPException(status_code=404, detail="Product not found in local cache.")
        
    return product
