# 🎨 Zelux - Stylist-First Beauty Platform

**A modern beauty booking platform connecting customers with professional stylists**

---

## 📊 Project Status

**Version:** 1.4.0 (Retail & Product Discovery)  
**Status:** ✅ Deployed & Running  
**Server:** AWS EC2 (3.24.31.8:8006)  
**Last Updated:** October 17, 2025

---

## 🏗️ Architecture

```
┌─────────────────┐         ┌──────────────────┐         ┌─────────────────┐
│  Flutter App    │────────▶│   FastAPI        │────────▶│   PostgreSQL    │
│  (Mobile/Web)   │  HTTP   │   Backend        │         │   Database      │
│  Port: -        │         │   Port: 8006     │         │   Port: 5432    │
└─────────────────┘         └──────────────────┘         └─────────────────┘
     Laptop/Mobile              AWS Server                   Docker Container
```

---

## 🎯 Core Features

### ✅ Implemented (MVP)
- 🔍 **Salon & Stylist Discovery** - Browse and search professionals
- 🔗 **External Booking Links** - Open salon booking pages (no in-app flow)
- 🛍️ **Retail & Product Discovery** - AI-powered product search, price tracking, watchlist
- 👤 **User Authentication** - Mock auth (ready for Firebase)
- ⭐ **Reviews & Ratings** - Social proof system
- 📱 **Mobile-First UI** - Beautiful Material Design 3
- 🌐 **RESTful API** - FastAPI with OpenAPI docs

### 🚧 Planned (Future)
- 🤖 **AI Style Preview** - Try hairstyles before booking
- 💳 **Payment Processing** - Stripe integration
- 🔔 **Push Notifications** - Booking reminders
- 💬 **In-App Chat** - Customer-stylist messaging
- 📊 **Analytics Dashboard** - Business insights

---

## 🛠️ Tech Stack

### Frontend (Mobile/Web)
- **Framework:** Flutter 3.x
- **Language:** Dart 3.x
- **State Management:** Riverpod
- **Navigation:** GoRouter
- **HTTP Client:** Dio + Retrofit
- **UI:** Material Design 3, Google Fonts

### Backend (API)
- **Framework:** FastAPI (Python 3.10)
- **Database:** PostgreSQL 15
- **ORM:** SQLAlchemy 2.0
- **Migrations:** Alembic
- **Validation:** Pydantic
- **Server:** Uvicorn

### Infrastructure
- **Hosting:** AWS EC2 (Ubuntu)
- **Database:** Docker (PostgreSQL)
- **Version Control:** Git/GitHub

---

## 📂 Project Structure (Simplified!)

```
Zelus/
├── backend/                 # FastAPI backend
│   ├── app/
│   │   ├── routers/        # API endpoints
│   │   ├── models/         # Database models
│   │   ├── schemas/        # Pydantic schemas
│   │   └── main.py         # App entry point
│   ├── alembic/            # Database migrations
│   ├── requirements.txt    # Python dependencies
│   └── .env                # Environment config
│
├── mobile/                  # Flutter mobile app (CLEANED!)
│   ├── lib/
│   │   ├── core/           # Core utilities (11 files)
│   │   │   ├── api/        # API client
│   │   │   ├── theme/      # Design system (charcoal/gold)
│   │   │   ├── router/     # Navigation (starts at /login)
│   │   │   └── widgets/    # Shared UI components (6 widgets)
│   │   ├── data/           # Data layer (12 files)
│   │   │   ├── models/     # 6 data models
│   │   │   └── services/   # 6 business services
│   │   ├── ai/             # AI features (2 files)
│   │   ├── features/
│   │   │   └── screens/    # ALL SCREENS (11 files in 1 folder!)
│   │   └── main.dart       # App entry point
│   └── pubspec.yaml        # Flutter dependencies
│
├── PROJECT_OVERVIEW.md      # This file
├── BACKEND.md              # Backend documentation
└── README.md               # Quick start guide

```

---

## 🚀 Quick Start

### Prerequisites
- Python 3.10+ (Backend)
- Flutter 3.0+ (Mobile)
- Docker (Database)

### Start Backend
```bash
cd backend
source venv/bin/activate
uvicorn app.main:app --host 0.0.0.0 --port 8006 --reload
```

### Start Mobile App
```bash
cd mobile
flutter pub get
flutter run -d chrome  # or Android/iOS
```

**Login:** `demo@zelux.com` / `any password`

---

## 📡 API Endpoints

**Base URL:** `http://3.24.31.8:8006/api/v1`

### Main Endpoints
- `GET /salons` - List salons
- `GET /salons/{id}` - Get salon details
- `GET /stylists/{id}` - Get stylist profile
- `GET /stylists/{id}/services` - Get services

**API Docs:** http://3.24.31.8:8006/docs

---

## 📊 Database Schema

### Core Tables
- **users** - Customer accounts
- **salons** - Salon locations (includes `booking_url`)
- **stylists** - Professional stylists
- **services** - Services offered

### Sample Data
- ✅ 3 salons (Elite Hair Studio, Color Studio NYC, Downtown Barbers)
- ✅ 4 stylists (Jane Smith, Michael Chen, Sarah Johnson, Mike Brown)
- ✅ 7 services (haircuts, color, balayage, etc.)
- ✅ 3 users (demo@zelux.com, customer1@example.com, customer2@example.com)

---

## 🔐 Security & Configuration

### Current Setup
- ✅ Mock authentication (development)
- ✅ Environment variables (.env)
- ✅ AWS Security Group (port 8006 open)
- ⚠️ HTTP only (HTTPS for production)

### Production Todos
- [ ] Enable Firebase authentication
- [ ] Configure HTTPS/SSL
- [ ] Add rate limiting
- [ ] Enable CORS restrictions
- [ ] Set up backups

---

## 📈 Progress Tracking

### October 14, 2025 - **Beauty Pro Network Phase 1 MVP Complete!** 🎉
- ✅ **Professional Profiles System**
  - ProProfile model with freezed + json_serializable
  - Full profile pages with portfolio, reviews, ratings
  - Book Now opens external salon `bookingUrl`
  - AI review summaries (≥10 reviews)
  - Follow system ready
- ✅ **Enhanced Discovery & Search**
  - New Explore screen with advanced filters (city, service, rating)
  - Professional vs Salon tabs
  - Personalization scoring (local)
  - 5-tab bottom navigation (Salons/Pros/Feed/Saved/Profile)
- ✅ **Content Upload & AI Features**
  - Upload screen with photo/video support
  - AI auto-tagging stub (ready for Vision API)
  - AI caption suggestions stub (ready for GPT-4)
  - AI review summarization stub
  - Weekly trend radar stub
- ✅ **Social & Collections**
  - Collections manager screen
  - Save/unsave posts
  - SaveButton & FollowButton widgets
  - Trending screen for external content
- ✅ **External Trend Integration**
  - oEmbed service for Instagram/TikTok
  - EmbeddedPostWidget with WebView
  - Attribution footer with platform logos
  - Deep-link support
- ✅ **Video Infrastructure (Stubs)**
  - Cloudflare Stream service stub
  - Video player widget (HLS support)
  - MediaTile for photo/video display
- ✅ **Feature Flags System**
  - Toggle all features via FeatureFlags class
  - 19+ feature flags implemented
- ✅ **Mock Data & Services**
  - 8 data models with freezed
  - 9 service layer classes
  - 4 AI stub services
  - 5 mock JSON data files
  - 10+ reusable UI widgets
- ✅ **Documentation**
  - Updated README.md with Phase 1 features
  - MIGRATION_NOTES.md (integration guide)
  - FEATURE_ACCESS_GUIDE.md (testing guide)
  - All routes documented

### October 15, 2025 - Design System Overhaul
- ✅ **UI Redesign Phase 2 Complete!**
  - Sophisticated charcoal & muted gold color palette
  - Light typography (w200-w400) with Inter font
  - Minimalist, luxurious design aesthetic
  - Consistent design system across all screens
  - Login page as entry point (email or phone)
  - 4-tab bottom navigation (Home, Explore, Saved, Profile)
  - Enhanced haptic feedback throughout
  - Pull-to-refresh on all major screens
- ✅ **Redesigned Screens:**
  - Discover Tab: Dynamic greeting, AI insights, trending styles
  - Profile Tab: Stats section, removed Quick Access icons
  - Explore Screen: Advanced filters with elegant UI
  - Collections: Refined grid layout with themed cards
  - Salon Detail: Enhanced info cards and booking button
  - Stylist Profile: Portfolio grid and review cards
  - Retail Tab: AI-powered product discovery with price tracking
- ✅ **Design Tokens:**
  - Primary: Charcoal #1F2937
  - Accent: Muted Gold #B8956A
  - Surface: Light Gray #F9FAFB
  - Typography: Inter with light weights

### October 12, 2025 - Social Platform Evolution
- ✅ Backend social endpoints: `/feed`, `/feed/trending`, tag stubs
- ✅ Mobile Feed tabs: For You / Trending / Following
- ✅ Reels full-screen vertical feed
- ✅ Login-gated engagement (like/comment)
- ✅ Stylist onboarding screen & route
- ✅ Tagging UI (MVP)

### October 12, 2025 - Initial Deployment
- ✅ Backend deployed on AWS (port 8006)
- ✅ PostgreSQL database running (Docker)
- ✅ Sample data seeded
- ✅ Mobile app configured
- ✅ Chrome web testing enabled
- ✅ AWS Security Group configured
- ✅ Firebase disabled for web testing

### Next Steps (Phase 2)
- [ ] Visual search (computer vision-based)
- [ ] Integrate real AI services (GPT-4, Vision API)
- [ ] Connect Cloudflare Stream (real video upload)
- [ ] Enable Firebase authentication
- [ ] Backend API integration (replace mock data)
- [ ] Instagram/TikTok oEmbed tokens
- [ ] Stripe payments integration
- [ ] Live video streaming
- [ ] Advanced analytics

---

## 🐛 Known Issues

1. **Firebase disabled for web** - Enabled Chrome testing, need to re-enable for production
2. **HTTP only** - Need HTTPS for production
3. **Mock payments** - Stripe integration pending

---

## 📚 Documentation

- **[README.md](README.md)** - Quick start guide
- **[PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)** - Project overview & progress (this file)
- **[BACKEND.md](BACKEND.md)** - Backend API & database
- **[mobile/README.md](mobile/README.md)** - Mobile app: setup, features, testing & integration

---

## 👥 Team & Support

**Repository:** https://github.com/qunexadmin/Zelus  
**Issues:** GitHub Issues  
**Deployment Date:** October 11, 2025

---

## 📝 Version History

### v1.4.0 - October 17, 2025 (Current - Retail & Product Discovery)
- 🛍️ **Retail Integration** - AI-powered product discovery merged into Explore
- **4-Tab Navigation:** Home, **Explore**, Saved, Profile (cleaner, more intuitive)
- **Explore Screen Enhanced:** 3 tabs → Professionals | Salons | **Retail**
  - All discovery features unified in one place
  - Seamless switching between pros, salons, and products
  - Better information architecture
- **Product Discovery:** AI-powered search for beauty products
- **Smart Features:**
  - Price drop alerts with green notification banners
  - Watchlist section with tracked products
  - Product cards with discount badges, ratings, save/bookmark
  - AI recommendations based on user visits
  - Trending products section
  - Hot deals & limited offers
- **Mock Data:** ~40 realistic beauty products (OLAPLEX, K18, DYSON, GHD, etc.)
- **Pricing:** $8 - $549 range with discounts up to 40% off
- **UI Consistency:** Same design system (charcoal/gold, light typography)
- **Future Ready:** Prepared for SerpAPI/Google Shopping API integration

### v1.3.0 - October 16, 2025 (Codebase Cleanup)
- 🧹 Massive codebase simplification
- **Folder Structure:** Consolidated 9 feature folders → 1 flat `screens/` folder (67% reduction!)
- **Data Layer:** Removed 3 unused files (stream_asset, cloudflare_stream_service, trend_service)
- **Core Widgets:** Removed 3 unused widgets (hashtag_chips, salon_card, save_button)
- **Deleted Features:** Removed unused feed, upload, and visual_search folders
- **Result:** 34 files cleaned up, all imports updated, zero linter errors
- **Navigation:** Super easy - all screens in one place!

### v1.2.0 - October 15, 2025 (Design System Overhaul)
- 🎨 Complete UI redesign with sophisticated design system
- Charcoal & muted gold color palette
- Light typography (Inter font, w200-w400 weights)
- Login page as entry point (email/phone, optional validation)
- 4-tab bottom navigation (Feed removed from nav)
- Redesigned all major screens (Discover, Profile, Explore, Collections, Salon, Stylist)
- Enhanced haptic feedback throughout
- Pull-to-refresh on all major screens
- Removed Quick Access section from Profile
- Consistent design language across the app

### v1.1.0 - October 14, 2025 (Phase 1 MVP)
- ✨ Beauty Pro Network Phase 1 MVP
- Professional profiles with AI features
- Advanced discovery & filters
- Content upload with AI assistance
- Collections & external trends
- 8 data models, 9 services, 4 AI stubs
- Feature flags system
- Comprehensive documentation

### v1.0.0 - October 11-12, 2025
- Initial MVP deployment
- Social feed integration
- Mock authentication
- Sample data

---

**Built with ❤️ for beauty professionals and their clients**

