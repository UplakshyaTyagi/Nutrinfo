"""Firebase JWT authentication dependency."""
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
import firebase_admin
from firebase_admin import auth, credentials

from app.core.config import get_settings

settings = get_settings()

_bearer_scheme = HTTPBearer()

# Initialise Firebase Admin SDK once (idempotent).
if not firebase_admin._apps:
    cred = credentials.Certificate(settings.google_application_credentials) \
        if settings.google_application_credentials \
        else credentials.ApplicationDefault()
    firebase_admin.initialize_app(cred, {"projectId": settings.firebase_project_id})


async def get_current_user_uid(
    creds: HTTPAuthorizationCredentials = Depends(_bearer_scheme),
) -> str:
    """
    Validates the Firebase JWT from the Authorization header.
    Returns the Firebase UID string on success.
    Raises HTTP 401 on invalid/expired tokens.
    """
    try:
        decoded = auth.verify_id_token(creds.credentials)
        return decoded["uid"]
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials.",
            headers={"WWW-Authenticate": "Bearer"},
        ) from exc
