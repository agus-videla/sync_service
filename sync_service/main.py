from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from models import RiverRecordMetadata
from schemas import RiverRecordMetadataCreate
from database import database, get_db

app = FastAPI()

@app.on_event("startup")
async def startup():
    await database.connect()

@app.on_event("shutdown")
async def shutdown():
    await database.disconnect()

@app.get("/")
async def read_root():
    return {"message": "Hello World"}

@app.post("/river_register_metadata")
async def create_river_record(metadata: RiverRecordMetadataCreate, db: Session = Depends(get_db)):
    # Convert the Pydantic model to the SQLAlchemy model
    db_metadata = RiverRecordMetadata(
        arrival_time=metadata.arrivalTime,
        departure_time=metadata.departureTime,
        latitude=metadata.latitude,
        longitude=metadata.longitude,
        observations=metadata.observations,
    )

    db.add(db_metadata)
    db.commit()
    db.refresh(db_metadata)

    return {"id": db_metadata.id, "message": "River Record Metadata created successfully"}
