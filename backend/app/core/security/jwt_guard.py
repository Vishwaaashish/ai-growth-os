from fastapi import Header, HTTPException
from jose import jwt, JWTError

SECRET_KEY = "supersecret"
ALGORITHM = "HS256"


def decode_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except JWTError as e:
        raise HTTPException(status_code=403, detail=f"Token error: {str(e)}")


def verify_jwt(authorization: str = Header(None)):
    if not authorization:
        raise HTTPException(status_code=401, detail="Token required")

    try:
        token = authorization.split(" ")[1]
        payload = decode_token(token)
        return payload
    except Exception as e:
        raise HTTPException(status_code=403, detail=str(e))


