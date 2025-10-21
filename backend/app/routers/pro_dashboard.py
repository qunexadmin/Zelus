"""
Pro Dashboard API endpoints for Zelus Pro (Business App)
Endpoints for stylists and salon owners to manage their business
"""
from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime, date, timedelta
from ..db import get_db

router = APIRouter(prefix="/pro", tags=["Pro Dashboard"])


# ==================== DASHBOARD ====================

@router.get("/dashboard/stats")
async def get_dashboard_stats(db: Session = Depends(get_db)):
    """Get dashboard statistics for stylist/salon owner"""
    # Mock data - replace with real queries
    return {
        "today_bookings": 4,
        "today_earnings": 380.0,
        "new_messages": 3,
        "rating": 4.9,
        "total_clients": 45,
        "this_week_bookings": 18,
        "this_month_revenue": 2450.0,
    }


# ==================== BOOKINGS ====================

@router.get("/bookings", response_model=List[dict])
async def get_my_bookings(
    status: Optional[str] = None,
    start_date: Optional[date] = None,
    end_date: Optional[date] = None,
    db: Session = Depends(get_db)
):
    """Get bookings for the logged-in professional"""
    # Mock data - replace with real DB queries
    return [
        {
            "id": "1",
            "customer_id": "c1",
            "customer_name": "Sarah Wilson",
            "customer_phone": "(555) 123-4567",
            "customer_email": "sarah@example.com",
            "stylist_id": "s1",
            "stylist_name": "Jane Smith",
            "service_id": "srv1",
            "service_name": "Haircut & Style",
            "booking_date": datetime.now().isoformat(),
            "start_time": "10:00",
            "end_time": "11:00",
            "status": "confirmed",
            "price": 80.0,
            "notes": None,
            "created_at": datetime.now().isoformat(),
        },
        {
            "id": "2",
            "customer_id": "c2",
            "customer_name": "Emily Chen",
            "customer_phone": "(555) 234-5678",
            "customer_email": "emily@example.com",
            "stylist_id": "s1",
            "stylist_name": "Jane Smith",
            "service_id": "srv2",
            "service_name": "Color Treatment",
            "booking_date": datetime.now().isoformat(),
            "start_time": "14:00",
            "end_time": "16:00",
            "status": "confirmed",
            "price": 150.0,
            "notes": None,
            "created_at": datetime.now().isoformat(),
        }
    ]


@router.put("/bookings/{booking_id}/status")
async def update_booking_status(
    booking_id: str,
    status: str,
    cancellation_reason: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Update booking status (accept, reject, complete, cancel)"""
    # TODO: Implement real DB update
    return {
        "id": booking_id,
        "status": status,
        "cancellation_reason": cancellation_reason,
        "updated_at": datetime.now().isoformat(),
    }


# ==================== AVAILABILITY ====================

@router.post("/availability")
async def set_availability(
    date: date,
    time_slots: List[dict],
    db: Session = Depends(get_db)
):
    """Set available time slots for a specific date"""
    # TODO: Implement availability management
    return {
        "message": "Availability set successfully",
        "date": date.isoformat(),
        "slots": time_slots,
    }


@router.get("/availability")
async def get_availability(
    start_date: date,
    end_date: Optional[date] = None,
    db: Session = Depends(get_db)
):
    """Get availability for date range"""
    return {
        "availability": [
            {
                "date": start_date.isoformat(),
                "slots": ["09:00", "10:00", "11:00", "14:00", "15:00", "16:00"],
            }
        ]
    }


# ==================== CLIENTS ====================

@router.get("/clients", response_model=List[dict])
async def get_my_clients(db: Session = Depends(get_db)):
    """Get list of clients for the logged-in professional"""
    # Mock data
    return [
        {
            "id": "c1",
            "name": "Sarah Wilson",
            "email": "sarah@example.com",
            "phone": "(555) 123-4567",
            "total_visits": 12,
            "total_spent": 960.0,
            "last_visit": (datetime.now() - timedelta(days=7)).isoformat(),
            "notes": "Prefers natural looks",
        },
        {
            "id": "c2",
            "name": "Emily Chen",
            "email": "emily@example.com",
            "phone": "(555) 234-5678",
            "total_visits": 8,
            "total_spent": 720.0,
            "last_visit": (datetime.now() - timedelta(days=14)).isoformat(),
            "notes": "Allergic to certain dyes",
        },
    ]


@router.get("/clients/{client_id}")
async def get_client_details(client_id: str, db: Session = Depends(get_db)):
    """Get detailed client information"""
    return {
        "id": client_id,
        "name": "Sarah Wilson",
        "email": "sarah@example.com",
        "phone": "(555) 123-4567",
        "total_visits": 12,
        "total_spent": 960.0,
        "last_visit": (datetime.now() - timedelta(days=7)).isoformat(),
        "notes": "Prefers natural looks",
        "booking_history": [
            {
                "date": (datetime.now() - timedelta(days=7)).isoformat(),
                "service": "Haircut & Style",
                "price": 80.0,
            }
        ],
    }


@router.put("/clients/{client_id}/notes")
async def update_client_notes(
    client_id: str,
    notes: str,
    db: Session = Depends(get_db)
):
    """Update notes for a client"""
    return {"message": "Notes updated", "client_id": client_id, "notes": notes}


# ==================== EARNINGS ====================

@router.get("/earnings")
async def get_earnings(
    period: str = "week",  # today, week, month, year
    db: Session = Depends(get_db)
):
    """Get earnings data for specified period"""
    return {
        "period": period,
        "total_earnings": 2450.0,
        "total_bookings": 28,
        "average_per_booking": 87.5,
        "transactions": [
            {
                "id": "t1",
                "customer_name": "Sarah Wilson",
                "service": "Haircut & Style",
                "amount": 80.0,
                "date": datetime.now().isoformat(),
            },
            {
                "id": "t2",
                "customer_name": "Emily Chen",
                "service": "Color Treatment",
                "amount": 150.0,
                "date": (datetime.now() - timedelta(hours=5)).isoformat(),
            },
        ],
        "chart_data": [
            {"date": "Mon", "amount": 300},
            {"date": "Tue", "amount": 450},
            {"date": "Wed", "amount": 380},
            {"date": "Thu", "amount": 520},
            {"date": "Fri", "amount": 480},
            {"date": "Sat", "amount": 550},
            {"date": "Sun", "amount": 270},
        ],
    }


# ==================== PROFILE MANAGEMENT ====================

@router.put("/profile")
async def update_my_profile(
    profile_data: dict,
    db: Session = Depends(get_db)
):
    """Update professional's own profile"""
    # TODO: Implement profile update
    return {
        "message": "Profile updated successfully",
        "profile": profile_data,
    }


@router.post("/portfolio")
async def upload_portfolio_image(
    image_url: str,
    caption: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Upload image to portfolio"""
    return {
        "message": "Portfolio image uploaded",
        "image_url": image_url,
        "caption": caption,
    }


@router.delete("/portfolio")
async def delete_portfolio_image(
    image_url: str,
    db: Session = Depends(get_db)
):
    """Delete image from portfolio"""
    return {"message": "Portfolio image deleted", "image_url": image_url}


# ==================== SALON OWNER ENDPOINTS ====================

@router.get("/salon/{salon_id}/staff")
async def get_salon_staff(salon_id: str, db: Session = Depends(get_db)):
    """Get list of staff members (salon owners only)"""
    return [
        {
            "id": "s1",
            "name": "Jane Smith",
            "role": "Senior Stylist",
            "today_bookings": 12,
            "rating": 4.9,
            "phone": "(555) 111-2222",
            "email": "jane@salon.com",
        },
        {
            "id": "s2",
            "name": "Michael Chen",
            "role": "Color Specialist",
            "today_bookings": 8,
            "rating": 4.8,
            "phone": "(555) 222-3333",
            "email": "michael@salon.com",
        },
    ]


@router.get("/salon/{salon_id}/analytics")
async def get_salon_analytics(
    salon_id: str,
    period: str = "month",
    db: Session = Depends(get_db)
):
    """Get salon analytics (salon owners only)"""
    return {
        "period": period,
        "total_revenue": 12450.0,
        "total_bookings": 156,
        "active_staff": 6,
        "average_rating": 4.8,
        "top_services": [
            {"name": "Haircut", "count": 45, "revenue": 3600.0},
            {"name": "Color Treatment", "count": 28, "revenue": 4200.0},
            {"name": "Balayage", "count": 15, "revenue": 3000.0},
        ],
        "staff_performance": [
            {"name": "Jane Smith", "bookings": 52, "revenue": 4680.0, "rating": 4.9},
            {"name": "Michael Chen", "bookings": 38, "revenue": 3800.0, "rating": 4.8},
        ],
        "revenue_chart": [
            {"month": "Jan", "revenue": 10200},
            {"month": "Feb", "revenue": 11500},
            {"month": "Mar", "revenue": 12450},
        ],
    }


@router.post("/salon/{salon_id}/staff")
async def add_staff_member(
    salon_id: str,
    staff_data: dict,
    db: Session = Depends(get_db)
):
    """Add new staff member (salon owners only)"""
    return {
        "message": "Staff member added successfully",
        "staff": staff_data,
    }


@router.delete("/salon/{salon_id}/staff/{staff_id}")
async def remove_staff_member(
    salon_id: str,
    staff_id: str,
    db: Session = Depends(get_db)
):
    """Remove staff member (salon owners only)"""
    return {"message": "Staff member removed", "staff_id": staff_id}

