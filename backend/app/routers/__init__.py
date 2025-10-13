"""
Routers package - exports all API routers
"""
from app.routers import auth, salons, stylists, bookings, ai, feed

__all__ = ["auth", "salons", "stylists", "bookings", "ai", "feed"]

