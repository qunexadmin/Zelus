"""
Authentication utilities for Firebase JWT verification
"""
from fastapi import HTTPException, Security, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from typing import Optional
import jwt
from datetime import datetime, timedelta

from app.core.config import settings


security = HTTPBearer()


async def verify_firebase_token(
    credentials: HTTPAuthorizationCredentials = Security(security)
) -> dict:
    """
    Verify Firebase ID token and return decoded payload
    
    TODO: Integrate with Firebase Admin SDK for production
    Currently returns mock payload for development
    """
    token = credentials.credentials
    
    try:
        # TODO: Replace with actual Firebase verification
        # from firebase_admin import auth
        # decoded_token = auth.verify_id_token(token)
        
        # Mock verification for development
        # In production, this should verify against Firebase
        if token == "mock-token":
            return {
                "uid": "mock-user-id",
                "email": "demo@zelux.com",
                "name": "Demo User"
            }
        
        # Try to decode as JWT (for local testing)
        try:
            payload = jwt.decode(
                token, 
                settings.SECRET_KEY, 
                algorithms=[settings.ALGORITHM]
            )
            return payload
        except jwt.InvalidTokenError:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authentication token"
            )
            
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Could not validate credentials: {str(e)}"
        )


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    """
    Create a JWT access token for local development
    """
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(
            minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES
        )
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(
        to_encode, 
        settings.SECRET_KEY, 
        algorithm=settings.ALGORITHM
    )
    return encoded_jwt


async def get_current_user(token_data: dict = Security(verify_firebase_token)) -> dict:
    """
    Get current authenticated user from token
    """
    return token_data

