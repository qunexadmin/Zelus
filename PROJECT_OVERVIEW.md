# 🎨 Zelux - Stylist-First Beauty Platform

**A modern beauty booking platform connecting customers with professional stylists**

---

## 📊 Project Status

**Version:** 1.0.0 MVP  
**Status:** ✅ Deployed & Running  
**Server:** AWS EC2 (3.24.31.8:8006)  
**Last Updated:** October 12, 2025

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
- 📅 **Booking System** - Complete appointment flow
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

## 📂 Project Structure

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
├── mobile/                  # Flutter mobile app
│   ├── lib/
│   │   ├── features/       # Feature modules
│   │   ├── core/           # Shared utilities
│   │   └── main.dart       # App entry point
│   └── pubspec.yaml        # Flutter dependencies
│
├── PROJECT_OVERVIEW.md      # This file
├── BACKEND.md              # Backend documentation
├── FRONTEND.md             # Frontend documentation
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
- `POST /bookings` - Create booking
- `GET /bookings/{user_id}` - List user bookings

**API Docs:** http://3.24.31.8:8006/docs

---

## 📊 Database Schema

### Core Tables
- **users** - Customer accounts
- **salons** - Salon locations
- **stylists** - Professional stylists
- **services** - Services offered
- **bookings** - Appointments

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
  - Book Now integration (no payment yet)
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

### October 12, 2025 - Social Platform Evolution
- ✅ **UI Redesign Phase 1 Complete!**
  - Modern color palette (soft purple, pink gradients)
  - Gradient header with SliverAppBar
  - Floating glassmorphic search bar
  - Premium salon cards with shadows
  - Modern category chips with gradients
  - Social media-inspired aesthetics
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

### Main Docs
- **Project Overview:** [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) - This file
- **Backend Guide:** [BACKEND.md](BACKEND.md) - API & database docs
- **Frontend Guide:** [FRONTEND.md](FRONTEND.md) - Mobile app overview

### Phase 1 MVP Docs (Mobile)
- **Mobile README:** [mobile/README.md](mobile/README.md) - Setup & features
- **Migration Notes:** [mobile/MIGRATION_NOTES.md](mobile/MIGRATION_NOTES.md) - Changes & integration
- **Feature Access Guide:** [mobile/FEATURE_ACCESS_GUIDE.md](mobile/FEATURE_ACCESS_GUIDE.md) - Testing guide

---

## 👥 Team & Support

**Repository:** https://github.com/qunexadmin/Zelus  
**Issues:** GitHub Issues  
**Deployment Date:** October 11, 2025

---

## 📝 Version History

### v1.1.0 - October 14, 2025 (Current - Phase 1 MVP)
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
- Core booking features
- Social feed integration
- Mock authentication
- Sample data

---

**Built with ❤️ for beauty professionals and their clients**

