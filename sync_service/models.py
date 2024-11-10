from database import Base
from sqlalchemy import DateTime, Column, Integer, String, Float

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

