from fastapi import Header, HTTPException
from app.core.security.jwt_guard import decode_token

def require_admin(authorization: str = Header(...)):
    try:
        token = authorization.split(" ")[1]
        payload = decode_token(token)

        if payload.get("role") != "admin":
            raise HTTPException(status_code=403, detail="Admin only")

        return payload

    except Exception:
        raise HTTPException(status_code=401, detail="Invalid token")
