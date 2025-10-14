"""
Stylist model for Zelux platform
"""
from sqlalchemy import Column, String, Text, Float, DateTime, Boolean, ForeignKey, Integer, JSON
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid

from app.db import Base


class Stylist(Base):
    """Stylist model - professionals offering services"""
    __tablename__ = "stylists"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=True)
    salon_id = Column(String, ForeignKey("salons.id"), nullable=False)
    
    # Profile
    name = Column(String, nullable=False)
    bio = Column(Text, nullable=True)
    specialties = Column(JSON, nullable=True)  # List of specialties
    years_experience = Column(Integer, default=0)
    
    # Media
    profile_image_url = Column(String, nullable=True)
    portfolio_images = Column(JSON, nullable=True)  # List of image URLs
    
    # Ratings
    rating = Column(Float, default=0.0)
    review_count = Column(Integer, default=0)
    
    # Pricing
    base_price = Column(Float, default=0.0)
    
    # Status
    is_active = Column(Boolean, default=True)
    is_verified = Column(Boolean, default=False)
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    salon = relationship("Salon", back_populates="stylists")
    services = relationship("Service", back_populates="stylist")


class Service(Base):
    """Service offered by a stylist"""
    __tablename__ = "services"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    stylist_id = Column(String, ForeignKey("stylists.id"), nullable=False)
    
    # Service details
    name = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    category = Column(String, nullable=False)  # e.g., "haircut", "color", "styling"
    duration_minutes = Column(Integer, nullable=False)
    price = Column(Float, nullable=False)
    
    # Media
    image_url = Column(String, nullable=True)
    
    # Status
    is_active = Column(Boolean, default=True)
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    stylist = relationship("Stylist", back_populates="services")

