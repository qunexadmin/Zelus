"""
Pydantic schemas for Salon model
"""
from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class SalonBase(BaseModel):
    """Base salon schema"""
    name: str
    description: Optional[str] = None
    address: str
    city: str
    state: Optional[str] = None
    zip_code: Optional[str] = None
    country: str = "USA"
    phone: Optional[str] = None
    email: Optional[str] = None
    website: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    cover_image_url: Optional[str] = None
    logo_url: Optional[str] = None


class SalonCreate(SalonBase):
    """Schema for creating a salon"""
    pass


class SalonUpdate(BaseModel):
    """Schema for updating a salon"""
    name: Optional[str] = None
    description: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    zip_code: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[str] = None
    website: Optional[str] = None
    cover_image_url: Optional[str] = None
    logo_url: Optional[str] = None
    is_active: Optional[bool] = None


class SalonResponse(SalonBase):
    """Schema for salon response"""
    id: str
    rating: float
    review_count: float
    is_active: bool
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True


class SalonListResponse(BaseModel):
    """Schema for paginated salon list"""
    salons: list[SalonResponse]
    total: int
    page: int
    page_size: int

