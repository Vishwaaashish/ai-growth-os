from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from database import engine
from redis_client import r
import models
from deps import get_db

models.Base.metadata.create_all(bind=engine)

app = FastAPI()

@app.get("/")
def root():
    return {"message": "System Running"}

@app.post("/create-user")
def create_user(name: str, email: str, db: Session = Depends(get_db)):
    new_user = models.User(name=name, email=email)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

@app.get("/users")
def get_users(db: Session = Depends(get_db)):
    return db.query(models.User).all()

@app.get("/create-lead")
def create_lead(name: str, email: str, phone: str, business_type: str, db: Session = Depends(get_db)):
    new_lead = models.Lead(
        name=name,
        email=email,
        phone=phone,
        business_type=business_type
    )
    db.add(new_lead)
    db.commit()
    db.refresh(new_lead)

    # 🔥 Push to Redis Queue
    r.lpush("lead_queue", f"{name}|{email}|{phone}|{business_type}")

    return new_lead

@app.get("/leads")
def get_leads(db: Session = Depends(get_db)):
    return db.query(models.Lead).all()
