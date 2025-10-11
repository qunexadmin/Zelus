"""
Pydantic schemas for Stylist and Service models
"""
from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List


# Service Schemas
class ServiceBase(BaseModel):
    """Base service schema"""
    name: str
    description: Optional[str] = None
    category: str
    duration_minutes: int
    price: float
    image_url: Optional[str] = None


class ServiceCreate(ServiceBase):
    """Schema for creating a service"""
    stylist_id: str


class ServiceUpdate(BaseModel):
    """Schema for updating a service"""
    name: Optional[str] = None
    description: Optional[str] = None
    category: Optional[str] = None
    duration_minutes: Optional[int] = None
    price: Optional[float] = None
    image_url: Optional[str] = None
    is_active: Optional[bool] = None


class ServiceResponse(ServiceBase):
    """Schema for service response"""
    id: str
    stylist_id: str
    is_active: bool
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True


# Stylist Schemas
class StylistBase(BaseModel):
    """Base stylist schema"""
    name: str
    bio: Optional[str] = None
    specialties: Optional[List[str]] = None
    years_experience: int = 0
    profile_image_url: Optional[str] = None
    portfolio_images: Optional[List[str]] = None
    base_price: float = 0.0


class StylistCreate(StylistBase):
    """Schema for creating a stylist"""
    salon_id: str
    user_id: Optional[str] = None


class StylistUpdate(BaseModel):
    """Schema for updating a stylist"""
    name: Optional[str] = None
    bio: Optional[str] = None
    specialties: Optional[List[str]] = None
    years_experience: Optional[int] = None
    profile_image_url: Optional[str] = None
    portfolio_images: Optional[List[str]] = None
    base_price: Optional[float] = None
    is_active: Optional[bool] = None


class StylistResponse(StylistBase):
    """Schema for stylist response"""
    id: str
    salon_id: str
    user_id: Optional[str]
    rating: float
    review_count: int
    is_active: bool
    is_verified: bool
    created_at: datetime
    updated_at: datetime
    services: List[ServiceResponse] = []
    
    class Config:
        from_attributes = True


class StylistDetailResponse(StylistResponse):
    """Schema for detailed stylist response with salon info"""
    salon_name: Optional[str] = None
    salon_address: Optional[str] = None

