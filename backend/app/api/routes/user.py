from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.session import SessionLocal
from app.schemas.user import UserCreate, UserResponse
from app.schemas.response import StandardResponse
from app.services.user import create_user, get_users

router = APIRouter()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("/", response_model=StandardResponse)
def create_user_api(user: UserCreate, db: Session = Depends(get_db)):
    new_user = create_user(db, user.email, user.password, user.tenant_id)

    if not new_user:
        return StandardResponse(
            success=False, data=None, message="Email already exists"
        )

    user_data = UserResponse.model_validate(new_user)

    return StandardResponse(success=True, data=user_data, message="User created")


@router.get("/", response_model=StandardResponse)
def get_users_api(db: Session = Depends(get_db)):
    users = get_users(db)

    users_data = [UserResponse.model_validate(u) for u in users]

    return StandardResponse(success=True, data=users_data, message="Users fetched")
