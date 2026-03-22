from uuid import uuid4
from datetime import datetime, timezone
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from app.core.database import get_db
from app.core.security import verify_firebase_token
from app.models.db_models import User
from app.schemas.pydantic_schemas import AuthSyncResponse

router = APIRouter(prefix="/auth", tags=["Auth"])

class UserSync(BaseModel):
    display_name: str | None = None
    email: str | None = None
    dietary_focus: str = "None"

@router.post("/sync", response_model=AuthSyncResponse)
async def sync_user(
    user_data: UserSync,
    db: AsyncSession = Depends(get_db),
    uid: str = Depends(verify_firebase_token)
):
    """
    Syncs the Firebase User with the SQLite local database.
    Called by the Flutter app right after Firebase Login or Onboarding.
    """
    stmt = select(User).where(User.firebase_uid == uid)
    res = await db.execute(stmt)
    user = res.scalars().first()
    
    if user:
        # Update existing user preferences
        if user_data.dietary_focus:
            user.dietary_focus = user_data.dietary_focus
        if user_data.display_name:
            user.display_name = user_data.display_name
        if user_data.email:
            user.email = user_data.email
            
        await db.commit()
        await db.refresh(user)
        return {"status": "updated", "user": user}
        
    # Create new user
    new_user = User(
        id=str(uuid4()),
        firebase_uid=uid,
        display_name=user_data.display_name or "Anonymous",
        email=user_data.email or "",
        dietary_focus=user_data.dietary_focus,
        created_at=datetime.now(timezone.utc)
    )
    
    db.add(new_user)
    await db.commit()
    await db.refresh(new_user)
    return {"status": "created", "user": new_user}
