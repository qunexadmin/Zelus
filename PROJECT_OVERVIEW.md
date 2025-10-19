# 🎨 Zelux - Stylist-First Beauty Platform

**A modern beauty booking platform connecting customers with professional stylists**

---

## 📊 Project Status

**Version:** 1.5.3 (Social-First Home)  
**Status:** ✅ Deployed & Running  
**Database:** Neon PostgreSQL - zelus (Serverless)  
**Server:** AWS EC2 (3.24.31.8:8006)  
**Last Updated:** October 19, 2025

---

## 🏗️ Architecture

```
┌─────────────────┐         ┌──────────────────┐         ┌─────────────────┐
│  Flutter App    │────────▶│   FastAPI        │────────▶│   PostgreSQL    │
│  (Mobile/Web)   │  HTTP   │   Backend        │         │   (Neon)        │
│  Port: -        │         │   Port: 8006     │         │   Serverless    │
└─────────────────┘         └──────────────────┘         └─────────────────┘
     Laptop/Mobile              AWS Server                  Neon Cloud (AWS)
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
- 🤝 **Social Features** - Follow system, activity feed, engagement
- 💬 **Messaging & AI Assistant** - Direct chat with stylists/salons + smart AI helper

### 🚧 Planned (Future)
- 🤖 **AI Style Preview** - Try hairstyles before booking
- 💳 **Payment Processing** - Stripe integration
- 🔔 **Push Notifications** - Booking reminders
- 📊 **Analytics Dashboard** - Business insights
- 🎥 **Video Calls** - Virtual consultations

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
- **Database:** Neon PostgreSQL 17.5 (Serverless)
- **ORM:** SQLAlchemy 2.0
- **Migrations:** Alembic
- **Validation:** Pydantic
- **Server:** Uvicorn

### Infrastructure
- **Hosting:** AWS EC2 (Ubuntu)
- **Database:** Neon PostgreSQL (Serverless, AWS ap-southeast-1)
- **Version Control:** Git/GitHub

---

## 📂 Project Structure (Clean & Simple!)

```
Zelus/
├── backend/                 # FastAPI backend
│   ├── app/                # Application code
│   │   ├── routers/        # API endpoints
│   │   ├── models/         # Database models (SQLAlchemy)
│   │   ├── schemas/        # Pydantic schemas
│   │   ├── core/           # Config & utilities
│   │   ├── db.py           # Database setup
│   │   └── main.py         # FastAPI app entry
│   ├── alembic/            # Database migrations
│   │   ├── versions/       # Migration files
│   │   └── env.py          # Alembic config
│   ├── media/              # Uploaded media files
│   ├── requirements.txt    # Python dependencies
│   ├── env.example         # Environment template
│   ├── alembic.ini         # Alembic configuration
│   └── seed_data.py        # Sample data loader
│
├── mobile/                  # Flutter mobile app
│   ├── lib/
│   │   ├── core/           # Core utilities
│   │   │   ├── api/        # API client (Dio)
│   │   │   ├── theme/      # Design system (charcoal/gold)
│   │   │   ├── router/     # Navigation (GoRouter)
│   │   │   └── widgets/    # Reusable UI components
│   │   ├── data/           # Data layer
│   │   │   ├── models/     # Data models (freezed)
│   │   │   └── services/   # Business logic
│   │   ├── features/       # Feature screens
│   │   │   └── screens/    # All UI screens (14 files)
│   │   └── main.dart       # Flutter app entry
│   ├── assets/             # Images, fonts, etc.
│   └── pubspec.yaml        # Flutter dependencies
│
├── PROJECT_OVERVIEW.md      # Complete project documentation
├── BACKEND.md              # Backend setup guide
└── .gitignore              # Git ignore rules

```

---

## 🚀 Quick Start

### Prerequisites
- Python 3.10+ (Backend)
- Flutter 3.0+ (Mobile)
- Neon account (Database - serverless, no local setup needed)

### Start Backend (AWS Server)
```bash
cd backend
source venv/bin/activate
uvicorn app.main:app --host 0.0.0.0 --port 8006 --reload
```

### Start Mobile App (Your Laptop)
```bash
cd mobile
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs  # Generate freezed files
flutter run -d chrome  # or android/ios
```

**Login:** Enter any email/phone (fields are optional for development)

**App Icon Setup (Optional):** To change the app icon, see [`APP_ICON_SETUP.md`](mobile/APP_ICON_SETUP.md)

### What You'll See (v1.5.3)
- **Elegant Login Page** - Clean minimal design with ZELUS branding
- **3-Tab Navigation** - Home | Explore | Profile (clean & minimal!)
- **Home Tab** - Smart sticky navigation (Instagram-style)
  - **Dynamic Greeting** + Messages icon (always visible)
  - **Utilities Section** (scrolls away):
    - **Smart Search Box** - Light gray search bar with white voice button (🎤)
    - **Quick Suggestion Chips** - 2 rows with specific contextual actions:
      - "Get style ideas for your Oct 25th appointment"
      - "3 items on sale in your watchlist"
      - "Book with Jane at Elite Studio"
    - **Appointment + Visit Cards** - Side-by-side compact design
  - **Sticky Tabs** (Following | Trending) - Stick after scrolling, no gray divider
  - **Following Tab**: Activity feed from followed stylists
  - **Trending Tab**: Special offers + Trending styles
- **Explore Tab** - Professionals | Salons | **Retail** (all discovery unified)
  - Browse pros with advanced filters (Book + Message buttons on each card)
  - Find salons near you
  - Discover beauty products with price tracking
- **Profile Tab** - Stats, Favorites, Social (Following, Saved), Account settings
- **Modern UX** - Utilities scroll away, tabs stay accessible
- **Clean Codebase** - 14 screens in one folder, easy to navigate
- **Haptic Feedback** - Enhanced touch interactions throughout
- **Pull-to-Refresh** - On all major screens

### Test the Flow
1. Run: `flutter run -d chrome`
2. **Login** - Enter any email/phone → Tap "Sign In"
3. **Home** - See utilities + 2 tabs
   - **Top**: AI Assistant, Appointment, Visit (scroll down to hide)
   - **Tabs stick**: Following | Trending (always accessible)
   - **Following**: Activity feed from stylists you follow
   - **Trending**: Special offers + Trending styles
   - Tap Messages icon for AI chat
   - **Try scrolling**: Utilities scroll away, tabs stick!
4. **Explore** - Browse professionals (Book + Message buttons), salons, products
5. **Profile** - View Favorites, Following, Saved Collections, Settings
6. **Follow stylists in Explore** - See their posts in Home → Following tab
7. **Tap any profile** - View portfolio, book, message

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

### October 18, 2025 - Infrastructure Overhaul
- ✅ **Database Migration to Neon**
  - Migrated from local Docker PostgreSQL to Neon
  - Neon PostgreSQL 17.5 (Serverless) configured
  - All tables migrated via Alembic
  - Sample data re-seeded to Neon
- ✅ **Project Cleanup**
  - Removed Docker setup (containers, volumes, networks)
  - Removed docker-compose.yml and Dockerfile
  - Cleaned Python cache files (__pycache__, .pyc)
  - Removed temporary migration/cleanup docs
  - Added comprehensive .gitignore
  - Simplified to 2 core documentation files
- ✅ **Testing & Verification**
  - API tested and verified with Neon
  - All endpoints working correctly
  - Documentation updated

### October 12, 2025 - Initial Deployment
- ✅ Backend deployed on AWS (port 8006)
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

- **[PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)** - Complete project documentation (this file)
- **[BACKEND.md](BACKEND.md)** - Backend API & database details

---

## 👥 Team & Support

**Repository:** https://github.com/qunexadmin/Zelus  
**Issues:** GitHub Issues  
**Deployment Date:** October 11, 2025

---

## 🗄️ About Alembic (Database Migrations)

**What is Alembic?**
Alembic is your database version control system. Think of it like Git, but for your database schema.

**Why is it important?**
- **Track Changes:** Every database change is recorded as a migration file
- **Version Control:** Rollback to previous database states if needed
- **Team Collaboration:** Share database changes across your team
- **Production Safety:** Apply tested changes to production databases

**How it works:**
```bash
# 1. Make changes to your models (e.g., add a new column to User model)
# 2. Create a migration
alembic revision --autogenerate -m "add bio field to user"

# 3. Review the generated migration file in alembic/versions/
# 4. Apply the migration
alembic upgrade head

# 5. If needed, rollback
alembic downgrade -1
```

**Never delete the alembic folder!** It contains your database history.

---

## 📝 Version History

### v1.5.3 - October 19, 2025 (Current)
- 🏠 **Home Screen** - Instagram-style layout with sticky tabs (Following | Trending)
- 🔍 **Smart Search** - Voice-enabled search with contextual suggestions
- 💬 **Messages** - Chat feature with AI assistant
- 📱 **3-Tab Navigation** - Home, Explore, Profile
- 🎨 **App Branding** - "ZELUS" name with custom icon (see `APP_ICON_SETUP.md`)

### v1.5.0 - October 18, 2025
- 🤝 **Social Features** - Follow system, activity feed, engagement
- 💬 **Messaging** - Chat with stylists and AI assistant
- 🗄️ **Database** - Migrated to Neon PostgreSQL

### v1.4.0 - October 17, 2025
- 🛍️ **Retail Integration** - Product discovery in Explore tab

### v1.3.0 - October 16, 2025
- 🧹 **Codebase Cleanup** - Simplified folder structure

### v1.2.0 - October 15, 2025
- 🎨 **Design System** - Charcoal & gold theme, minimal typography

### v1.1.0 - October 14, 2025
- ✨ **Phase 1 MVP** - Professional profiles, discovery, collections

### v1.0.0 - October 11-12, 2025
- 🚀 **Initial Release** - Basic social feed and authentication

---

**Built with ❤️ for beauty professionals and their clients**

