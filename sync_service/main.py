from fastapi import FastAPI, HTTPException, Depends
from databases import Database
from sqlalchemy import DateTime, create_engine, Column, Integer, String, Float, Time
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from models import RiverRecordMetadataCreate
import os


DATABASE_URL = f"postgresql://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
print(DATABASE_URL)
database = Database(DATABASE_URL)

Base = declarative_base()
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

class RiverRecordMetadata(Base):
    __tablename__ = 'river_record_metadata'
    id = Column(Integer, primary_key=True, index=True)
    record_id = Column(Integer, nullable=True)
    weather_id = Column(Integer, nullable=True)
    water_color = Column(String, nullable=True)
    river_status = Column(String, nullable=True)
    monitoring_id = Column(Integer, nullable=True)
    river_gauge_id = Column(Integer, nullable=True)
    observations = Column(String, nullable=True)
    laboratory = Column(String, nullable=True)
    arrival_time = Column(DateTime, nullable=True)
    departure_time = Column(DateTime, nullable=True)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    subregion_id = Column(Integer, nullable=True)


app = FastAPI()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()




@app.on_event("startup")
async def startup():
    await database.connect()

@app.on_event("shutdown")
async def shutdown():
    await database.disconnect()

@app.get("/")
async def read_root():
    return {"message": "Hello World"}

@app.post("/river_register")
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
