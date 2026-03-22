from pydantic import BaseModel

class CommandCreate(BaseModel):
    user_id: str
    input_text: str

class CommandResponse(BaseModel):
    id: int
    user_id: str
    input_text: str
    output_text: str
    status: str

    class Config:
        from_attributes = True
