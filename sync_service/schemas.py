from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class RiverRecordMetadataCreate(BaseModel):
    arrivalTime: datetime
    departureTime: datetime
    latitude: Optional[float] = 0
    longitude: Optional[float] = 0
    observations: Optional[str] = "No observations"
    isSynced: bool

    class Config:
        from_attributes = True  # allows the model to be used with SQLAlchemy ORM if needed later

