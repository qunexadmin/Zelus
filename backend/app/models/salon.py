"""
Salon model for Zelux platform
"""
from sqlalchemy import Column, String, Text, Float, DateTime, Boolean
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid

from app.db import Base


class Salon(Base):
    """Salon/Studio model"""
    __tablename__ = "salons"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    name = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    address = Column(String, nullable=False)
    city = Column(String, nullable=False)
    state = Column(String, nullable=True)
    zip_code = Column(String, nullable=True)
    country = Column(String, default="USA")
    
    # Contact
    phone = Column(String, nullable=True)
    email = Column(String, nullable=True)
    website = Column(String, nullable=True)
    booking_url = Column(String, nullable=True)
    
    # Location
    latitude = Column(Float, nullable=True)
    longitude = Column(Float, nullable=True)
    
    # Media
    cover_image_url = Column(String, nullable=True)
    logo_url = Column(String, nullable=True)
    
    # Ratings
    rating = Column(Float, default=0.0)
    review_count = Column(Float, default=0)
    
    # Status
    is_active = Column(Boolean, default=True)
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    stylists = relationship("Stylist", back_populates="salon")

