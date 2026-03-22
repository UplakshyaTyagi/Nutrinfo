from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload

from app.core.database import get_db
from app.core.security import verify_firebase_token
from app.models.db_models import ScanHistory, User
from app.schemas.pydantic_schemas import ScanHistoryResponse

router = APIRouter(prefix="/history", tags=["History"])

@router.get("", response_model=list[ScanHistoryResponse])
async def get_user_scan_history(
    limit: int = 20,
    offset: int = 0,
    db: AsyncSession = Depends(get_db),
    uid: str = Depends(verify_firebase_token)
):
    """Get the authenticated user's scan history, joined with the Product details."""
    user_stmt = select(User).where(User.firebase_uid == uid)
    user_res = await db.execute(user_stmt)
    user = user_res.scalars().first()
    
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    hist_stmt = (
        select(ScanHistory)
        .where(ScanHistory.user_id == user.id)
        .options(selectinload(ScanHistory.product))
        .order_by(ScanHistory.scanned_at.desc())
        .limit(limit)
        .offset(offset)
    )
    hist_res = await db.execute(hist_stmt)
    history = hist_res.scalars().all()
    
    return history
