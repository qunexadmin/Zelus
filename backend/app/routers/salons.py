"""
Salons router - handles salon discovery and details
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import Optional

from app.db import get_db
from app.models import Salon
from app.schemas import SalonResponse, SalonListResponse


router = APIRouter(prefix="/salons", tags=["Salons"])


@router.get("", response_model=SalonListResponse)
async def list_salons(
    page: int = Query(1, ge=1),
    page_size: int = Query(10, ge=1, le=100),
    city: Optional[str] = None,
    search: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """
    List all salons with pagination and filters
    """
    query = db.query(Salon).filter(Salon.is_active == True)
    
    # Apply filters
    if city:
        query = query.filter(Salon.city.ilike(f"%{city}%"))
    if search:
        query = query.filter(
            (Salon.name.ilike(f"%{search}%")) |
            (Salon.description.ilike(f"%{search}%"))
        )
    
    # Get total count
    total = query.count()
    
    # Apply pagination
    offset = (page - 1) * page_size
    salons = query.order_by(Salon.rating.desc()).offset(offset).limit(page_size).all()
    
    return SalonListResponse(
        salons=[SalonResponse.model_validate(salon) for salon in salons],
        total=total,
        page=page,
        page_size=page_size
    )


@router.get("/{salon_id}", response_model=SalonResponse)
async def get_salon(
    salon_id: str,
    db: Session = Depends(get_db)
):
    """
    Get detailed information about a specific salon
    """
    salon = db.query(Salon).filter(Salon.id == salon_id).first()
    
    if not salon:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Salon not found"
        )
    
    return SalonResponse.model_validate(salon)


@router.get("/{salon_id}/stylists")
async def get_salon_stylists(
    salon_id: str,
    db: Session = Depends(get_db)
):
    """
    Get all stylists for a specific salon
    """
    from app.models import Stylist
    from app.schemas import StylistResponse
    
    salon = db.query(Salon).filter(Salon.id == salon_id).first()
    if not salon:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Salon not found"
        )
    
    stylists = db.query(Stylist).filter(
        Stylist.salon_id == salon_id,
        Stylist.is_active == True
    ).all()
    
    return [StylistResponse.model_validate(stylist) for stylist in stylists]

