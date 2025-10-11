"""
Pydantic schemas for Booking model
"""
from pydantic import BaseModel
from datetime import datetime
from typing import Optional
from app.models.booking import BookingStatus, PaymentStatus


class BookingBase(BaseModel):
    """Base booking schema"""
    scheduled_at: datetime
    customer_notes: Optional[str] = None


class BookingCreate(BookingBase):
    """Schema for creating a booking"""
    stylist_id: str
    service_id: str


class BookingUpdate(BaseModel):
    """Schema for updating a booking"""
    scheduled_at: Optional[datetime] = None
    status: Optional[BookingStatus] = None
    customer_notes: Optional[str] = None
    stylist_notes: Optional[str] = None


class BookingResponse(BookingBase):
    """Schema for booking response"""
    id: str
    user_id: str
    stylist_id: str
    service_id: str
    duration_minutes: float
    total_price: float
    status: BookingStatus
    payment_status: PaymentStatus
    payment_intent_id: Optional[str]
    stylist_notes: Optional[str]
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True


class BookingDetailResponse(BookingResponse):
    """Schema for detailed booking response with related info"""
    stylist_name: Optional[str] = None
    service_name: Optional[str] = None
    salon_name: Optional[str] = None


class BookingListResponse(BaseModel):
    """Schema for paginated booking list"""
    bookings: list[BookingDetailResponse]
    total: int
    page: int
    page_size: int

