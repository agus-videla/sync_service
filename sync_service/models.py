from pydantic import BaseModel
from datetime import datetime

class RiverRecordMetadataCreate(BaseModel):
    arrivalTime: datetime
    departureTime: datetime
    latitude: float
    longitude: float
    observations: str

    class Config:
        from_attributes = True  # allows the model to be used with SQLAlchemy ORM if needed later
