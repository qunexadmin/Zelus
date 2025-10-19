"""
Professionals (pros) router - Mobile app compatibility alias for stylists
This is essentially the same as stylists but uses /pros path for mobile app
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import Optional

from app.db import get_db
from app.models import Stylist, Service, Salon
from app.schemas import StylistResponse, StylistDetailResponse, ServiceResponse


router = APIRouter(prefix="/pros", tags=["Professionals"])


@router.get("", response_model=list[StylistResponse])
async def list_professionals(
    page: int = Query(1, ge=1),
    page_size: int = Query(10, ge=1, le=100),
    city: Optional[str] = None,
    service: Optional[str] = None,
    min_rating: Optional[float] = None,
    db: Session = Depends(get_db)
):
    """
    List all professionals (stylists) with pagination and filters
    Mobile app endpoint
    """
    query = db.query(Stylist).filter(Stylist.is_active == True)
    
    # Apply filters
    if city:
        # Filter by salon city
        salon_ids = db.query(Salon.id).filter(Salon.city.ilike(f"%{city}%")).all()
        salon_ids = [s[0] for s in salon_ids]
        query = query.filter(Stylist.salon_id.in_(salon_ids))
    
    if min_rating:
        query = query.filter(Stylist.rating >= min_rating)
    
    # Get total count
    total = query.count()
    
    # Apply pagination
    offset = (page - 1) * page_size
    stylists = query.order_by(Stylist.rating.desc()).offset(offset).limit(page_size).all()
    
    return [StylistResponse.model_validate(stylist) for stylist in stylists]


@router.get("/{pro_id}", response_model=StylistDetailResponse)
async def get_professional(
    pro_id: str,
    db: Session = Depends(get_db)
):
    """
    Get detailed information about a specific professional (stylist)
    Mobile app endpoint
    """
    stylist = db.query(Stylist).filter(Stylist.id == pro_id).first()
    
    if not stylist:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Professional not found"
        )
    
    # Get salon information
    salon = db.query(Salon).filter(Salon.id == stylist.salon_id).first()
    
    # Convert to response model
    stylist_data = StylistResponse.model_validate(stylist)
    
    # Add location field for mobile app
    location = f"{salon.city}, {salon.state}" if salon else None
    
    return StylistDetailResponse(
        **stylist_data.model_dump(),
        salon_name=salon.name if salon else None,
        salon_address=salon.address if salon else None,
        location=location
    )


@router.get("/{pro_id}/services", response_model=list[ServiceResponse])
async def get_professional_services(
    pro_id: str,
    db: Session = Depends(get_db)
):
    """
    Get all services offered by a specific professional (stylist)
    Mobile app endpoint
    """
    stylist = db.query(Stylist).filter(Stylist.id == pro_id).first()
    
    if not stylist:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Professional not found"
        )
    
    services = db.query(Service).filter(
        Service.stylist_id == pro_id,
        Service.is_active == True
    ).all()
    
    return [ServiceResponse.model_validate(service) for service in services]

