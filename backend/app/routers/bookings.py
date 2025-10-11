"""
Bookings router - handles booking creation and management
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import Optional

from app.db import get_db
from app.core.auth import get_current_user
from app.models import Booking, Service, Stylist, Salon, User
from app.schemas import BookingCreate, BookingResponse, BookingDetailResponse, BookingListResponse
from app.models.booking import BookingStatus, PaymentStatus


router = APIRouter(prefix="/bookings", tags=["Bookings"])


@router.post("", response_model=BookingDetailResponse)
async def create_booking(
    booking_data: BookingCreate,
    current_user: dict = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Create a new booking
    
    TODO: Integrate with payment processor (Stripe)
    TODO: Send confirmation notifications
    """
    # Verify service exists
    service = db.query(Service).filter(Service.id == booking_data.service_id).first()
    if not service:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Service not found"
        )
    
    # Verify stylist exists
    stylist = db.query(Stylist).filter(Stylist.id == booking_data.stylist_id).first()
    if not stylist:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Stylist not found"
        )
    
    # Check if slot is available (simplified - in production, check for conflicts)
    # TODO: Implement proper availability checking
    
    # Create booking
    booking = Booking(
        user_id=current_user.get("sub"),
        stylist_id=booking_data.stylist_id,
        service_id=booking_data.service_id,
        scheduled_at=booking_data.scheduled_at,
        duration_minutes=service.duration_minutes,
        total_price=service.price,
        customer_notes=booking_data.customer_notes,
        status=BookingStatus.PENDING,
        payment_status=PaymentStatus.PENDING
    )
    
    db.add(booking)
    db.commit()
    db.refresh(booking)
    
    # Get related information for response
    salon = db.query(Salon).filter(Salon.id == stylist.salon_id).first()
    
    return BookingDetailResponse(
        **BookingResponse.model_validate(booking).model_dump(),
        stylist_name=stylist.name,
        service_name=service.name,
        salon_name=salon.name if salon else None
    )


@router.get("/{user_id}", response_model=BookingListResponse)
async def list_user_bookings(
    user_id: str,
    page: int = Query(1, ge=1),
    page_size: int = Query(10, ge=1, le=100),
    status: Optional[BookingStatus] = None,
    current_user: dict = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    List all bookings for a specific user
    """
    # Verify user can access these bookings (must be the user or admin)
    if current_user.get("sub") != user_id:
        # TODO: Check if user is admin
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to access these bookings"
        )
    
    query = db.query(Booking).filter(Booking.user_id == user_id)
    
    # Apply status filter
    if status:
        query = query.filter(Booking.status == status)
    
    # Get total count
    total = query.count()
    
    # Apply pagination
    offset = (page - 1) * page_size
    bookings = query.order_by(Booking.scheduled_at.desc()).offset(offset).limit(page_size).all()
    
    # Enrich with related data
    booking_details = []
    for booking in bookings:
        stylist = db.query(Stylist).filter(Stylist.id == booking.stylist_id).first()
        service = db.query(Service).filter(Service.id == booking.service_id).first()
        salon = db.query(Salon).filter(Salon.id == stylist.salon_id).first() if stylist else None
        
        booking_details.append(BookingDetailResponse(
            **BookingResponse.model_validate(booking).model_dump(),
            stylist_name=stylist.name if stylist else None,
            service_name=service.name if service else None,
            salon_name=salon.name if salon else None
        ))
    
    return BookingListResponse(
        bookings=booking_details,
        total=total,
        page=page,
        page_size=page_size
    )


@router.get("/details/{booking_id}", response_model=BookingDetailResponse)
async def get_booking(
    booking_id: str,
    current_user: dict = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Get detailed information about a specific booking
    """
    booking = db.query(Booking).filter(Booking.id == booking_id).first()
    
    if not booking:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Booking not found"
        )
    
    # Verify user can access this booking
    if booking.user_id != current_user.get("sub"):
        # TODO: Check if user is admin or the stylist
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to access this booking"
        )
    
    # Get related information
    stylist = db.query(Stylist).filter(Stylist.id == booking.stylist_id).first()
    service = db.query(Service).filter(Service.id == booking.service_id).first()
    salon = db.query(Salon).filter(Salon.id == stylist.salon_id).first() if stylist else None
    
    return BookingDetailResponse(
        **BookingResponse.model_validate(booking).model_dump(),
        stylist_name=stylist.name if stylist else None,
        service_name=service.name if service else None,
        salon_name=salon.name if salon else None
    )


@router.patch("/{booking_id}/cancel")
async def cancel_booking(
    booking_id: str,
    current_user: dict = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Cancel a booking
    
    TODO: Implement refund logic if payment was made
    """
    booking = db.query(Booking).filter(Booking.id == booking_id).first()
    
    if not booking:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Booking not found"
        )
    
    # Verify user can cancel this booking
    if booking.user_id != current_user.get("sub"):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to cancel this booking"
        )
    
    # Check if booking can be cancelled
    if booking.status == BookingStatus.COMPLETED:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot cancel a completed booking"
        )
    
    booking.status = BookingStatus.CANCELLED
    db.commit()
    
    return {"message": "Booking cancelled successfully"}

