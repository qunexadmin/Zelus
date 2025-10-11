"""
Core configuration settings for Zelux backend
"""
from pydantic_settings import BaseSettings
from typing import Optional


class Settings(BaseSettings):
    """Application settings loaded from environment variables"""
    
    # API Settings
    API_V1_STR: str = "/api/v1"
    PROJECT_NAME: str = "Zelux API"
    
    # Database
    DATABASE_URL: str = "postgresql://zelux_user:zelux_password@localhost:5432/zelux_db"
    
    # Firebase Auth
    FIREBASE_PROJECT_ID: Optional[str] = None
    FIREBASE_API_KEY: Optional[str] = None
    
    # Security
    SECRET_KEY: str = "your-secret-key-change-in-production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 7 days
    
    # CORS
    BACKEND_CORS_ORIGINS: list = ["http://localhost:3000", "http://localhost:8080"]
    
    # Media Storage
    MEDIA_ROOT: str = "./media"
    MEDIA_URL: str = "/media"
    
    # AI Service (Placeholder for Nano Banana)
    AI_SERVICE_URL: Optional[str] = None
    AI_SERVICE_API_KEY: Optional[str] = None
    
    # Payment (Placeholder for Stripe)
    STRIPE_SECRET_KEY: Optional[str] = None
    STRIPE_PUBLISHABLE_KEY: Optional[str] = None
    
    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()

