"""
Authentication router - handles user authentication and registration
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.db import get_db
from app.core.auth import verify_firebase_token, create_access_token
from app.models import User
from app.schemas import UserCreate, UserResponse, TokenResponse


router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post("/verify-token", response_model=TokenResponse)
async def verify_token(
    token_data: dict = Depends(verify_firebase_token),
    db: Session = Depends(get_db)
):
    """
    Verify Firebase ID token and return user info with access token
    
    TODO: Integrate with Firebase Admin SDK for production
    This endpoint verifies the Firebase token and creates/returns the user
    """
    firebase_uid = token_data.get("uid")
    email = token_data.get("email")
    name = token_data.get("name", email.split("@")[0] if email else "User")
    
    # Check if user exists
    user = db.query(User).filter(User.firebase_uid == firebase_uid).first()
    
    if not user:
        # Create new user
        user = User(
            firebase_uid=firebase_uid,
            email=email,
            name=name
        )
        db.add(user)
        db.commit()
        db.refresh(user)
    
    # Create access token for API
    access_token = create_access_token(
        data={"sub": user.id, "email": user.email}
    )
    
    return TokenResponse(
        access_token=access_token,
        user=UserResponse.model_validate(user)
    )


@router.post("/login")
async def login(
    credentials: dict,
    db: Session = Depends(get_db)
):
    """
    Login endpoint for Zelus Pro app (simplified auth for development)
    
    For development/testing - returns mock user based on email
    TODO: Implement proper password validation for production
    """
    # Mock authentication - for development only
    # In production, verify password hash here
    
    email = credentials.get("email")
    phone = credentials.get("phone")
    password = credentials.get("password")
    
    if not email and not phone:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email or phone is required"
        )
    
    # Mock user responses based on email
    if email == "demo@zelus.com" or email == "stylist@zelus.com":
        # Return stylist user
        return {
            "token": "mock_token_stylist",
            "user": {
                "id": "stylist_1",
                "email": email or "stylist@zelus.com",
                "phone": phone,
                "name": "Demo Stylist",
                "photo_url": None,
                "role": "stylist",
                "stylist_id": "s1",
                "salon_id": None,
                "created_at": "2025-01-01T00:00:00",
                "last_login": "2025-01-20T00:00:00",
                "is_verified": True,
                "is_active": True
            }
        }
    elif email == "owner@zelus.com" or email == "salon@zelus.com":
        # Return salon owner user
        return {
            "token": "mock_token_owner",
            "user": {
                "id": "owner_1",
                "email": email or "owner@zelus.com",
                "phone": phone,
                "name": "Salon Owner",
                "photo_url": None,
                "role": "salon_owner",
                "stylist_id": None,
                "salon_id": "salon_1",
                "created_at": "2025-01-01T00:00:00",
                "last_login": "2025-01-20T00:00:00",
                "is_verified": True,
                "is_active": True
            }
        }
    else:
        # Default customer user
        return {
            "token": "mock_token_customer",
            "user": {
                "id": "customer_1",
                "email": email or "customer@zelus.com",
                "phone": phone,
                "name": "Customer",
                "photo_url": None,
                "role": "customer",
                "stylist_id": None,
                "salon_id": None,
                "created_at": "2025-01-01T00:00:00",
                "last_login": "2025-01-20T00:00:00",
                "is_verified": True,
                "is_active": True
            }
        }


@router.post("/register", response_model=TokenResponse)
async def register_user(
    user_data: UserCreate,
    db: Session = Depends(get_db)
):
    """
    Register a new user (alternative to Firebase for testing)
    """
    # Check if user already exists
    existing_user = db.query(User).filter(User.email == user_data.email).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User with this email already exists"
        )
    
    # Create new user
    user = User(**user_data.model_dump())
    db.add(user)
    db.commit()
    db.refresh(user)
    
    # Create access token
    access_token = create_access_token(
        data={"sub": user.id, "email": user.email}
    )
    
    return TokenResponse(
        access_token=access_token,
        user=UserResponse.model_validate(user)
    )


@router.get("/me", response_model=UserResponse)
async def get_current_user_info(
    token_data: dict = Depends(verify_firebase_token),
    db: Session = Depends(get_db)
):
    """
    Get current authenticated user information
    """
    user_id = token_data.get("sub")
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    return UserResponse.model_validate(user)

