from fastapi import APIRouter, HTTPException
from typing import List, Dict, Any, Optional
from datetime import datetime, timedelta

router = APIRouter(prefix="/feed", tags=["feed"])


def _mock_posts() -> List[Dict[str, Any]]:
    now = datetime.utcnow()
    return [
        {
            "id": "post-1",
            "stylist": {
                "id": "stylist-1",
                "name": "Jane Smith",
                "avatar_url": None,
                "username": "jane_smith",
                "followers": 12450,
            },
            "image_url": None,
            "caption": "Fresh balayage for fall 🍂",
            "likes": 234,
            "comments": 12,
            "created_at": (now - timedelta(hours=3)).isoformat() + "Z",
            "tags": ["#balayage", "#color", "#fallhair"],
        },
        {
            "id": "post-2",
            "stylist": {
                "id": "stylist-4",
                "name": "Mike Brown",
                "avatar_url": None,
                "username": "mike_barber",
                "followers": 8650,
            },
            "image_url": None,
            "caption": "Classic cut with a modern fade ✂️",
            "likes": 189,
            "comments": 8,
            "created_at": (now - timedelta(hours=8)).isoformat() + "Z",
            "tags": ["#barber", "#fade", "#menshair"],
        },
        {
            "id": "post-3",
            "stylist": {
                "id": "stylist-3",
                "name": "Sarah Johnson",
                "avatar_url": None,
                "username": "sarah_colors",
                "followers": 15320,
            },
            "image_url": None,
            "caption": "Natural highlights that pop ✨",
            "likes": 301,
            "comments": 25,
            "created_at": (now - timedelta(days=1)).isoformat() + "Z",
            "tags": ["#highlights", "#natural", "#hairgoals"],
        },
    ]


@router.get("")
def get_feed() -> Dict[str, Any]:
    return {"posts": _mock_posts()}


@router.get("/trending")
def get_trending() -> Dict[str, Any]:
    posts = _mock_posts()
    # Simple engagement score: likes + 2*comments, higher first
    posts.sort(key=lambda p: (p.get("likes", 0) + 2 * p.get("comments", 0)), reverse=True)
    return {"posts": posts}


@router.post("/{post_id}/tag-salon")
def tag_salon(post_id: str, salon_id: str) -> Dict[str, Any]:
    # Mock success response; persistence to be added when DB schema is extended
    if post_id not in {"post-1", "post-2", "post-3"}:
        raise HTTPException(status_code=404, detail="Post not found")
    return {"status": "ok", "post_id": post_id, "salon_id": salon_id}


@router.post("/{post_id}/tag-stylist")
def tag_stylist(post_id: str, stylist_id: str) -> Dict[str, Any]:
    if post_id not in {"post-1", "post-2", "post-3"}:
        raise HTTPException(status_code=404, detail="Post not found")
    return {"status": "ok", "post_id": post_id, "stylist_id": stylist_id}


@router.delete("/{post_id}/tag-salon/{salon_id}")
def untag_salon(post_id: str, salon_id: str) -> Dict[str, Any]:
    return {"status": "ok", "post_id": post_id, "salon_id": salon_id}


@router.delete("/{post_id}/tag-stylist/{stylist_id}")
def untag_stylist(post_id: str, stylist_id: str) -> Dict[str, Any]:
    return {"status": "ok", "post_id": post_id, "stylist_id": stylist_id}


