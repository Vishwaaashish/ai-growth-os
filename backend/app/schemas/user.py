from pydantic import BaseModel


class UserCreate(BaseModel):
    email: str
    password: str
    tenant_id: int


class UserResponse(BaseModel):
    id: int
    email: str
    tenant_id: int

    class Config:
        from_attributes = True
