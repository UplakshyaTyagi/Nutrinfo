from uuid import uuid4
from datetime import datetime, timezone
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, Field
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from app.core.database import get_db
from app.core.security import get_current_user_uid
from app.models.db_models import Review, User, Product
from app.schemas.pydantic_schemas import ReviewResponse

router = APIRouter(prefix="/reviews", tags=["Reviews"])

class ReviewCreate(BaseModel):
    product_id: str = Field(..., description="UUID of the product being reviewed.")
    rating: int = Field(..., ge=1, le=5)
    body: str

@router.post("", response_model=ReviewResponse)
async def create_review(
    review_in: ReviewCreate,
    db: AsyncSession = Depends(get_db),
    uid: str = Depends(get_current_user_uid)
):
    """Allow users to rate and review food products."""
    user_stmt = select(User).where(User.firebase_uid == uid)
    user_res = await db.execute(user_stmt)
    user = user_res.scalars().first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    prod_stmt = select(Product).where(Product.id == review_in.product_id)
    prod_res = await db.execute(prod_stmt)
    if not prod_res.scalars().first():
        raise HTTPException(status_code=404, detail="Product not found")

    new_review = Review(
        id=str(uuid4()),
        user_id=user.id,
        product_id=review_in.product_id,
        rating=review_in.rating,
        body=review_in.body,
        created_at=datetime.now(timezone.utc)
    )
    db.add(new_review)
    await db.commit()
    await db.refresh(new_review)
    return new_review

@router.get("/{product_id}", response_model=list[ReviewResponse])
async def get_product_reviews(
    product_id: str,
    db: AsyncSession = Depends(get_db)
):
    """Get all reviews for a specific active product."""
    stmt = select(Review).where(Review.product_id == product_id).order_by(Review.created_at.desc())
    res = await db.execute(stmt)
    return res.scalars().all()
