"""Auth0 JWT authentication dependency."""
import httpx
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import jwt, JWTError

from app.core.config import get_settings

settings = get_settings()

_bearer_scheme = HTTPBearer()

# Auth0 JWKS endpoint — cached after first fetch.
_jwks: dict | None = None


async def _get_jwks() -> dict:
    """Fetch the JSON Web Key Set from Auth0 (cached in-memory)."""
    global _jwks
    if _jwks is not None:
        return _jwks

    jwks_url = f"https://{settings.auth0_domain}/.well-known/jwks.json"
    async with httpx.AsyncClient() as client:
        resp = await client.get(jwks_url)
        resp.raise_for_status()
        _jwks = resp.json()
        return _jwks


async def get_current_user_uid(
    creds: HTTPAuthorizationCredentials = Depends(_bearer_scheme),
) -> str:
    """
    Validates the Auth0 JWT from the Authorization header.
    Returns the Auth0 user `sub` claim (e.g. "auth0|abc123") on success.
    Raises HTTP 401 on invalid/expired tokens.
    """
    token = creds.credentials

    try:
        # Decode the JWT header to find the key ID
        unverified_header = jwt.get_unverified_header(token)
        kid = unverified_header.get("kid")

        # Find the matching public key in the JWKS
        jwks = await _get_jwks()
        rsa_key = {}
        for key in jwks.get("keys", []):
            if key["kid"] == kid:
                rsa_key = key
                break

        if not rsa_key:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Unable to find appropriate key.",
                headers={"WWW-Authenticate": "Bearer"},
            )

        # Verify and decode the token
        payload = jwt.decode(
            token,
            rsa_key,
            algorithms=["RS256"],
            audience=settings.auth0_api_audience,
            issuer=f"https://{settings.auth0_domain}/",
        )

        # Return the Auth0 user ID (sub claim)
        sub: str | None = payload.get("sub")
        if sub is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Token missing 'sub' claim.",
                headers={"WWW-Authenticate": "Bearer"},
            )
        return sub

    except JWTError as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials.",
            headers={"WWW-Authenticate": "Bearer"},
        ) from exc
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials.",
            headers={"WWW-Authenticate": "Bearer"},
        ) from exc
