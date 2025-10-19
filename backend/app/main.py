"""
Zelux API - Main FastAPI application
A stylist-first platform connecting customers with professional stylists
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import os

from app.core.config import settings
from app.routers import auth, salons, stylists, pros, ai, feed
from app.db import init_db


# Create FastAPI application
app = FastAPI(
    title=settings.PROJECT_NAME,
    version="1.0.0",
    description="Backend API for Zelux - Stylist-First Beauty Platform",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Create media directory if it doesn't exist
os.makedirs(settings.MEDIA_ROOT, exist_ok=True)

# Mount static files for media
app.mount(settings.MEDIA_URL, StaticFiles(directory=settings.MEDIA_ROOT), name="media")

# Include routers
app.include_router(auth.router, prefix=settings.API_V1_STR)
app.include_router(salons.router, prefix=settings.API_V1_STR)
app.include_router(stylists.router, prefix=settings.API_V1_STR)
app.include_router(pros.router, prefix=settings.API_V1_STR)  # Mobile app compatibility (/pros alias)
app.include_router(ai.router, prefix=settings.API_V1_STR)
app.include_router(feed.router, prefix=settings.API_V1_STR)


@app.on_event("startup")
async def startup_event():
    """Initialize database on startup"""
    print("🚀 Starting Zelux API...")
    print("📊 Initializing database...")
    init_db()
    print("✅ Database initialized!")


@app.get("/")
async def root():
    """Root endpoint - API health check"""
    return {
        "message": "Welcome to Zelux API",
        "version": "1.0.0",
        "status": "healthy",
        "docs": "/docs"
    }


@app.get("/health")
async def health_check():
    """Health check endpoint for monitoring"""
    return {
        "status": "healthy",
        "service": "zelux-api"
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )

