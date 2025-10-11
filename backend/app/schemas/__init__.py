"""
Schemas package - exports all Pydantic schemas
"""
from app.schemas.user import (
    UserBase, UserCreate, UserUpdate, UserResponse, TokenResponse
)
from app.schemas.salon import (
    SalonBase, SalonCreate, SalonUpdate, SalonResponse, SalonListResponse
)
from app.schemas.stylist import (
    ServiceBase, ServiceCreate, ServiceUpdate, ServiceResponse,
    StylistBase, StylistCreate, StylistUpdate, StylistResponse, StylistDetailResponse
)
from app.schemas.booking import (
    BookingBase, BookingCreate, BookingUpdate, BookingResponse,
    BookingDetailResponse, BookingListResponse
)

__all__ = [
    # User schemas
    "UserBase", "UserCreate", "UserUpdate", "UserResponse", "TokenResponse",
    # Salon schemas
    "SalonBase", "SalonCreate", "SalonUpdate", "SalonResponse", "SalonListResponse",
    # Service schemas
    "ServiceBase", "ServiceCreate", "ServiceUpdate", "ServiceResponse",
    # Stylist schemas
    "StylistBase", "StylistCreate", "StylistUpdate", "StylistResponse", "StylistDetailResponse",
    # Booking schemas
    "BookingBase", "BookingCreate", "BookingUpdate", "BookingResponse",
    "BookingDetailResponse", "BookingListResponse",
]

