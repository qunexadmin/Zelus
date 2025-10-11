"""
Stylists router - handles stylist profiles and services
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.db import get_db
from app.models import Stylist, Service, Salon
from app.schemas import StylistResponse, StylistDetailResponse, ServiceResponse


router = APIRouter(prefix="/stylists", tags=["Stylists"])


@router.get("/{stylist_id}", response_model=StylistDetailResponse)
async def get_stylist(
    stylist_id: str,
    db: Session = Depends(get_db)
):
    """
    Get detailed information about a specific stylist including services
    """
    stylist = db.query(Stylist).filter(Stylist.id == stylist_id).first()
    
    if not stylist:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Stylist not found"
        )
    
    # Get salon information
    salon = db.query(Salon).filter(Salon.id == stylist.salon_id).first()
    
    # Convert to response model
    stylist_data = StylistResponse.model_validate(stylist)
    
    return StylistDetailResponse(
        **stylist_data.model_dump(),
        salon_name=salon.name if salon else None,
        salon_address=salon.address if salon else None
    )


@router.get("/{stylist_id}/services", response_model=list[ServiceResponse])
async def get_stylist_services(
    stylist_id: str,
    db: Session = Depends(get_db)
):
    """
    Get all services offered by a specific stylist
    """
    stylist = db.query(Stylist).filter(Stylist.id == stylist_id).first()
    
    if not stylist:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Stylist not found"
        )
    
    services = db.query(Service).filter(
        Service.stylist_id == stylist_id,
        Service.is_active == True
    ).all()
    
    return [ServiceResponse.model_validate(service) for service in services]


@router.get("/{stylist_id}/availability")
async def get_stylist_availability(
    stylist_id: str,
    date: str,  # Format: YYYY-MM-DD
    db: Session = Depends(get_db)
):
    """
    Get available time slots for a stylist on a specific date
    
    TODO: Implement actual availability logic based on bookings and working hours
    This is a placeholder that returns mock available slots
    """
    stylist = db.query(Stylist).filter(Stylist.id == stylist_id).first()
    
    if not stylist:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Stylist not found"
        )
    
    # Mock available time slots (9 AM - 5 PM in 30-minute intervals)
    # TODO: Calculate actual availability based on existing bookings
    available_slots = [
        "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
        "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30"
    ]
    
    return {
        "date": date,
        "stylist_id": stylist_id,
        "available_slots": available_slots
    }

