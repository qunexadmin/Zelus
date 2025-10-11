"""
Booking model for Zelux platform
"""
from sqlalchemy import Column, String, Text, Float, DateTime, ForeignKey, Enum as SQLEnum
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid
import enum

from app.db import Base


class BookingStatus(str, enum.Enum):
    """Booking status enumeration"""
    PENDING = "pending"
    CONFIRMED = "confirmed"
    CANCELLED = "cancelled"
    COMPLETED = "completed"
    NO_SHOW = "no_show"


class PaymentStatus(str, enum.Enum):
    """Payment status enumeration"""
    PENDING = "pending"
    PAID = "paid"
    REFUNDED = "refunded"
    FAILED = "failed"


class Booking(Base):
    """Booking model - appointments between users and stylists"""
    __tablename__ = "bookings"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False)
    stylist_id = Column(String, ForeignKey("stylists.id"), nullable=False)
    service_id = Column(String, ForeignKey("services.id"), nullable=False)
    
    # Booking details
    scheduled_at = Column(DateTime, nullable=False)
    duration_minutes = Column(Float, nullable=False)
    
    # Status
    status = Column(
        SQLEnum(BookingStatus, native_enum=False),
        default=BookingStatus.PENDING,
        nullable=False
    )
    
    # Payment
    total_price = Column(Float, nullable=False)
    payment_status = Column(
        SQLEnum(PaymentStatus, native_enum=False),
        default=PaymentStatus.PENDING,
        nullable=False
    )
    payment_intent_id = Column(String, nullable=True)  # Stripe payment intent ID
    
    # Notes
    customer_notes = Column(Text, nullable=True)
    stylist_notes = Column(Text, nullable=True)
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    user = relationship("User", back_populates="bookings", foreign_keys=[user_id])
    stylist = relationship("Stylist", back_populates="bookings")
    service = relationship("Service")

