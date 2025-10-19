# 🔗 Backend Integration Plan

**Status:** ✅ PHASE 1 & 2 COMPLETE - Discovery Features Working!  
**Current State:** Mobile using REAL data for salons/stylists, mock for social features  
**Goal:** Add social & messaging endpoints (Phase 5 & 6)  
**Last Updated:** October 19, 2025

## ✅ Integration Status

- ✅ **Phase 1:** Added /pros endpoint - DONE
- ✅ **Phase 2:** Mock data disabled - DONE  
- ✅ **API Working:** Salons & Stylists loading from Neon database
- ⚠️ **Phase 5 & 6:** Social features (follow, messages) - PENDING

## ⚡ What's New

### v1.5.4 - October 19, 2025 (Current - Performance & UX Polish)
Mobile app optimizations:
- ⚡ **Enterprise Scrolling** - NestedScrollView, RefreshIndicator on ALL screens
- 🤖 **AI Assistant** - Bottom sheet (no keyboard popup, better UX)
- 💳 **Premium Cards** - Full-width appointment cards with quick actions
- 📱 **Pull-to-Refresh** - Every screen (Home, Explore, Profile, Stylist, Salon, Collections)
- 🎯 **Production-Ready** - 60fps scrolling, optimized architecture

**Backend Impact:** None - All frontend optimizations. Mobile ready for API integration!

### v1.5.3 - October 19, 2025 (Social Features)
Mobile app features requiring backend:
- 🤝 **Follow System** - Follow stylists, see follower counts
- 📱 **Activity Feed** - Instagram-style feed (Following | Trending tabs)
- 💬 **Messaging** - AI assistant + direct chat with stylists/salons
- 🧠 **Smart AI Suggestions** - Contextual quick actions
- ⭐ **Favorites** - Save stylists/salons to collections
- 🎯 **3-Tab Navigation** - Simplified to Home | Explore | Profile

**All of these need backend endpoints!** See Phase 5 & 6 below.

---

## 📊 Current Status

### ✅ Backend (FastAPI + Neon PostgreSQL)
| Component | Status | Details |
|-----------|--------|---------|
| **Database** | ✅ Running | Neon PostgreSQL - zelus (17.5) |
| **API Server** | ✅ Running | Port 8006, AWS EC2 (3.24.31.8) |
| **Data** | ✅ Seeded | 3 users, 3 salons, 4 stylists, 7 services |
| **CORS** | ✅ Configured | Allows mobile app connections |

### ⚠️ Mobile (Flutter)
| Component | Status | Details |
|-----------|--------|---------|
| **API Client** | ✅ Configured | Points to http://3.24.31.8:8006/api/v1 |
| **Data Source** | ⚠️ MOCK | `FeatureFlags.mockData = true` |
| **Services** | ✅ Ready | Have API calls + mock fallbacks |

---

## 🔍 API Endpoint Comparison

### Available Backend Endpoints:

| Endpoint | Method | Status | Mobile Uses |
|----------|--------|--------|-------------|
| `/api/v1/salons` | GET | ✅ Working | ✅ Yes |
| `/api/v1/salons/{id}` | GET | ✅ Working | ✅ Yes |
| `/api/v1/salons/{id}/stylists` | GET | ✅ Working | ✅ Yes |
| `/api/v1/stylists/{id}` | GET | ✅ Working | ❌ No (expects `/pros/{id}`) |
| `/api/v1/stylists/{id}/services` | GET | ✅ Working | ❌ No |
| `/api/v1/stylists/{id}/availability` | GET | ✅ Working | ❌ No |
| `/api/v1/auth/register` | POST | ✅ Working | ⚠️ Partial |
| `/api/v1/feed` | GET | ✅ Working | ✅ Yes |

### Missing Endpoints (Mobile Expects):

| Expected Endpoint | Current Equivalent | Action Needed |
|-------------------|-------------------|---------------|
| `/api/v1/pros` | `/api/v1/salons/{id}/stylists` | ✅ Use salon endpoint |
| `/api/v1/pros/{id}` | `/api/v1/stylists/{id}` | 🔧 Add alias or update mobile |

---

## 🎯 Integration Steps

### **PHASE 1: Enable Real API (Quick Win - 5 minutes)**

#### Step 1: Disable Mock Data
**File:** `mobile/lib/core/feature_flags.dart`
```dart
// Change this line:
static const bool mockData = true;

// To:
static const bool mockData = false;
```

#### Step 2: Test Connection
```bash
# In mobile directory:
flutter run -d chrome

# Expected: App loads data from backend
# If errors: Check console for API errors
```

**Expected Issues:**
- ❌ `/pros` endpoint not found (mobile expects, backend doesn't have)
- ✅ Salons will load fine
- ❌ Stylists won't load (wrong endpoint)

---

### **PHASE 2: Fix API Endpoint Mismatch (15 minutes)**

#### Option A: Add `/pros` Alias to Backend (Recommended)

**File:** `backend/app/routers/stylists.py`

Add at the top (after line 12):
```python
# Add alias for pros endpoint (mobile compatibility)
@router.get("", response_model=list[StylistResponse])
async def list_stylists(
    page: int = Query(1, ge=1),
    page_size: int = Query(10, ge=1, le=100),
    city: Optional[str] = None,
    service: Optional[str] = None,
    min_rating: Optional[float] = None,
    db: Session = Depends(get_db)
):
    """
    List all stylists with pagination and filters
    """
    query = db.query(Stylist).filter(Stylist.is_active == True)
    
    # Apply filters
    if city:
        salon_ids = db.query(Salon.id).filter(Salon.city.ilike(f"%{city}%"))
        query = query.filter(Stylist.salon_id.in_(salon_ids))
    if min_rating:
        query = query.filter(Stylist.rating >= min_rating)
    
    # Apply pagination
    offset = (page - 1) * page_size
    stylists = query.order_by(Stylist.rating.desc()).offset(offset).limit(page_size).all()
    
    return [StylistResponse.model_validate(stylist) for stylist in stylists]
```

Then register as `/pros` in `main.py`:
```python
# Add this line after line 42:
app.include_router(stylists.router, prefix=settings.API_V1_STR + "/pros", tags=["Professionals"])
```

#### Option B: Update Mobile App (Alternative)

**File:** `mobile/lib/data/services/profile_service.dart`

Change line 28:
```dart
// From:
final response = await _dio.get('/pros', ...

// To:
final response = await _dio.get('/stylists', ...
```

---

### **PHASE 3: Data Model Mapping (30 minutes)**

Mobile and backend have different field names. Need to map them:

| Mobile Field | Backend Field | Action |
|--------------|---------------|--------|
| `ProProfile.salonName` | Need to join | ✅ Backend already returns |
| `ProProfile.location` | Derive from salon | 🔧 Add to backend response |
| `ProProfile.photoUrl` | `profile_image_url` | ✅ Already matches |
| `ProProfile.priceRange` | Derive from `base_price` | 🔧 Calculate in mobile |

#### Update Backend Schema

**File:** `backend/app/schemas/__init__.py` (or create schemas.py)

Update `StylistDetailResponse`:
```python
class StylistDetailResponse(StylistResponse):
    salon_name: Optional[str] = None
    salon_address: Optional[str] = None
    location: Optional[str] = None  # Add this
    
    @classmethod
    def from_stylist_with_salon(cls, stylist: Stylist, salon: Salon):
        location = f"{salon.city}, {salon.state}" if salon else None
        return cls(
            **StylistResponse.model_validate(stylist).model_dump(),
            salon_name=salon.name if salon else None,
            salon_address=salon.address if salon else None,
            location=location
        )
```

---

### **PHASE 4: Authentication Integration (1 hour)**

Current: Mock auth in mobile, placeholder in backend

#### Backend Changes Needed:

1. **Add user registration endpoint** (already exists at `/auth/register`)
2. **Add login endpoint** (needs implementation)
3. **Add JWT token generation** (needs implementation)

#### Mobile Changes Needed:

1. **Store auth token** (use flutter_secure_storage)
2. **Add token to API requests** (in api_client.dart)
3. **Handle token refresh** (add interceptor)

**Priority:** Medium (can delay if testing discovery features first)

---

### **PHASE 5: New Social & Messaging Features (Required)**

**NEW** features added in v1.5.3 that need backend support:

| Feature | Mobile Support | Backend Status | Priority | Details |
|---------|---------------|----------------|----------|---------|
| **Follow System** | ✅ Implemented | ❌ No endpoint | **HIGH** | Follow/unfollow stylists, get followed IDs |
| **Activity Feed** | ✅ Implemented | ⚠️ Has feed endpoint | **HIGH** | Need filtering by followed stylists |
| **Follower Count** | ✅ Has UI | ❌ No endpoint | **HIGH** | Display follower count on profiles |
| **Messaging/Chat** | ✅ Has UI | ❌ No endpoint | **HIGH** | AI assistant + direct chat |
| **Smart Suggestions** | ✅ Has UI | ❌ No logic | **MEDIUM** | Contextual AI quick actions |
| **Favorites** | ✅ Has UI | ❌ No endpoint | MEDIUM | Save stylists/salons |
| **Collections** | ✅ Has UI | ❌ No endpoint | MEDIUM | Saved posts & bookmarks |
| Reviews | ✅ Has UI | ❌ No endpoint | MEDIUM | User reviews |
| Bookings | ✅ Has UI | ⚠️ Placeholder | LOW | External booking URLs work |
| Product Discovery | ✅ Has UI | ❌ No endpoint | LOW | Beauty products/retail |

---

### **PHASE 6: Backend Endpoints Needed (New Features)**

#### 1. Follow System Endpoints

**Required Endpoints:**
```python
# Follow/Unfollow
POST   /api/v1/stylists/{id}/follow      # Follow a stylist
DELETE /api/v1/stylists/{id}/follow      # Unfollow a stylist
GET    /api/v1/users/me/following        # Get IDs of followed stylists
GET    /api/v1/stylists/{id}/followers   # Get follower count

# Database changes needed:
# - Add "follows" table (user_id, stylist_id, created_at)
# - Add follower_count to stylists table (or calculate dynamically)
```

#### 2. Activity Feed Endpoints

**Required Endpoints:**
```python
# Feed with filtering
GET /api/v1/feed?filter=following&user_id={user_id}  # Posts from followed stylists only
GET /api/v1/feed?filter=trending                     # All popular posts

# Database changes needed:
# - Add "posts" table if not exists
# - Add stylist_id to posts table
# - Add like_count, comment_count for engagement
```

#### 3. Messaging Endpoints

**Required Endpoints:**
```python
# Conversations
GET    /api/v1/conversations                    # List user's conversations
GET    /api/v1/conversations/{id}/messages      # Get messages in conversation
POST   /api/v1/conversations/{id}/messages      # Send message
POST   /api/v1/conversations                    # Start new conversation

# AI Assistant
POST   /api/v1/ai/chat                          # Send message to AI assistant
GET    /api/v1/ai/suggestions                   # Get contextual suggestions

# Database changes needed:
# - Add "conversations" table
# - Add "messages" table
# - Consider WebSocket support for real-time chat
```

#### 4. Smart Suggestions Logic

**Required Endpoints:**
```python
GET /api/v1/users/me/suggestions  # Get personalized quick actions

# Returns contextual actions based on:
# - Upcoming appointments
# - Price drops on saved items
# - Last visited stylist
# - Following feed updates
# - Time since last visit
```

#### 5. Favorites/Collections Endpoints

**Required Endpoints:**
```python
# Favorites
POST   /api/v1/favorites                 # Add to favorites
DELETE /api/v1/favorites/{id}            # Remove from favorites
GET    /api/v1/users/me/favorites        # Get user's favorites

# Collections (Saved posts)
POST   /api/v1/collections               # Create collection
GET    /api/v1/collections               # List collections
POST   /api/v1/collections/{id}/posts    # Add post to collection
GET    /api/v1/collections/{id}/posts    # Get posts in collection

# Database changes needed:
# - Add "favorites" table (user_id, entity_type, entity_id)
# - Add "collections" table
# - Add "collection_posts" junction table
```

---

## 🚀 Quick Start Guide

### **Option 1: Test with Mock Data OFF (Fastest)**

```bash
# 1. Edit feature flags
cd /home/ubuntu/Zelus/mobile
# Edit lib/core/feature_flags.dart, set mockData = false

# 2. Run app
flutter run -d chrome

# 3. Check console for errors
# Expected: Salons load, stylists may fail (endpoint mismatch)
```

### **Option 2: Full Integration (Recommended)**

```bash
# 1. Add /pros endpoint to backend
cd /home/ubuntu/Zelus/backend
# Edit app/routers/stylists.py (add list_stylists function)

# 2. Restart API
pkill -f "uvicorn app.main:app"
source venv/bin/activate
uvicorn app.main:app --host 0.0.0.0 --port 8006 &

# 3. Disable mock data in mobile
cd /home/ubuntu/Zelus/mobile
# Edit lib/core/feature_flags.dart, set mockData = false

# 4. Run mobile app
flutter run -d chrome

# 5. Test all features
# - Browse salons ✅
# - View salon details ✅
# - Browse professionals ✅
# - View professional profiles ✅
```

---

## 🧪 Testing Checklist

### Salons (Should Work Immediately)
- [ ] List all salons on Explore > Salons tab
- [ ] Click salon to view details
- [ ] See 3 salons from database
- [ ] Filter by city

### Stylists/Professionals (Needs Fix)
- [ ] List all stylists on Explore > Professionals tab
- [ ] Click stylist to view profile
- [ ] See 4 stylists from database
- [ ] View stylist services

### Expected Issues
- ❌ Professionals tab: "No data" (needs `/pros` endpoint)
- ✅ Salons tab: Works perfectly
- ⚠️ Professional profiles: May have missing fields
- ⚠️ Services: May not display (different format)

---

## 📝 Code Changes Summary

### Backend Changes Required:

1. **Add `/pros` endpoint** (5 lines)
   - File: `backend/app/routers/stylists.py`
   - Add list_stylists function

2. **Register `/pros` route** (1 line)
   - File: `backend/app/main.py`
   - Add app.include_router for /pros

3. **Add location field** (5 lines)
   - File: `backend/app/schemas/__init__.py`
   - Update StylistDetailResponse

### Mobile Changes Required:

1. **Disable mock data** (1 line)
   - File: `mobile/lib/core/feature_flags.dart`
   - Change mockData to false

2. **Optional: Update endpoint names** (if not adding backend alias)
   - File: `mobile/lib/data/services/profile_service.dart`
   - Change `/pros` to `/stylists`

---

## 🎯 Recommended Approach

### **Today: Quick Test (15 minutes)**

1. Set `mockData = false` in mobile
2. Test what works (salons should work)
3. Document what fails (pros endpoint)

### **Tomorrow: Fix Endpoints (1 hour)**

1. Add `/pros` alias to backend
2. Restart API server
3. Test mobile app again
4. All data should load from database

### **Next Week: Full Integration (3-5 hours)**

1. Add authentication
2. Add missing endpoints (reviews, bookings)
3. Add messaging functionality
4. Polish error handling

---

## 🆘 Troubleshooting

### Mobile shows "No data"
**Check:**
1. Is API running? `curl http://3.24.31.8:8006/health`
2. Is mock data disabled? Check feature_flags.dart
3. Check browser console for errors
4. Check network tab in browser dev tools

### API returns 404
**Check:**
1. Is endpoint correct? `/api/v1/salons` vs `/salons`
2. Is data in database? `python verify_neon_db.py`
3. Check backend logs: `tail -f /tmp/zelux_api.log`

### CORS errors
**Check:**
1. CORS configured in backend? (Already done ✅)
2. Using correct URL? Must be http://3.24.31.8:8006

---

## 📊 Current Data Available

From your Neon database:

```
✅ 3 Salons:
   - Elite Hair Studio (salon-1)
   - Color Studio NYC (salon-2)
   - Downtown Barbers (salon-3)

✅ 4 Stylists:
   - Jane Smith (stylist-1, at Elite Hair Studio)
   - Michael Chen (stylist-2, at Elite Hair Studio)
   - Sarah Johnson (stylist-3, at Color Studio NYC)
   - Mike Brown (stylist-4, at Downtown Barbers)

✅ 7 Services:
   - Women's Haircut & Style ($75)
   - Balayage Color ($200)
   - Full Color ($150)
   - Fashion Color ($250)
   - Highlights ($180)
   - Men's Haircut ($45)
   - Beard Trim & Shape ($25)
```

---

## 🎉 Success Criteria

Integration is complete when:

1. ✅ Mobile app loads salons from Neon database
2. ✅ Mobile app loads stylists from Neon database
3. ✅ Can view salon details
4. ✅ Can view stylist profiles
5. ✅ Can see stylist services with prices
6. ✅ No mock data used
7. ✅ All 3 salons visible
8. ✅ All 4 stylists visible
9. ✅ All 7 services visible

---

**Next Action:** Set `mockData = false` and test! 🚀

---

**Last Updated:** October 19, 2025 (v1.5.4 - Performance & UX Polish)  
**Database:** Neon PostgreSQL - zelus  
**API:** http://3.24.31.8:8006/api/v1  
**Mobile Version:** v1.5.4 (Production-Ready)

