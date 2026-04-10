from sqlalchemy.orm import Session
from app.models.user import User
from sqlalchemy.exc import IntegrityError


def create_user(db: Session, email: str, password: str, tenant_id: int):
    try:
        user = User(email=email, password=password, tenant_id=tenant_id)
        db.add(user)
        db.commit()
        db.refresh(user)
        return user

    except IntegrityError:
        db.rollback()
        return None


def get_users(db: Session):
    return db.query(User).all()
