"""
Pydantic schemas for User model
"""
from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional


class UserBase(BaseModel):
    """Base user schema"""
    email: EmailStr
    name: str
    phone: Optional[str] = None
    profile_image_url: Optional[str] = None


class UserCreate(UserBase):
    """Schema for creating a user"""
    firebase_uid: Optional[str] = None
    is_stylist: bool = False


class UserUpdate(BaseModel):
    """Schema for updating a user"""
    name: Optional[str] = None
    phone: Optional[str] = None
    profile_image_url: Optional[str] = None


class UserResponse(UserBase):
    """Schema for user response"""
    id: str
    firebase_uid: Optional[str]
    is_stylist: bool
    is_admin: bool
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True


class TokenResponse(BaseModel):
    """Schema for token response"""
    access_token: str
    token_type: str = "bearer"
    user: UserResponse

