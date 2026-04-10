from pydantic import BaseModel
from typing import Any, Optional


class StandardResponse(BaseModel):
    success: bool
    data: Optional[Any]
    message: Optional[str]
