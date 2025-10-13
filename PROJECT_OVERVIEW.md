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

### October 12, 2025 - PM Session
- ✅ **UI Redesign Phase 1 Complete!**
  - Modern color palette (soft purple, pink gradients)
  - Gradient header with SliverAppBar
  - Floating glassmorphic search bar
  - Premium salon cards with shadows
  - Modern category chips with gradients
  - Social media-inspired aesthetics
- ✅ Documentation cleaned up (4 focused docs)
- ✅ Chrome web testing working
- 🎯 **Decision:** Converting to social media + booking hybrid platform

### October 12, 2025 - Later PM Session
- ✅ Backend social endpoints: `/feed`, `/feed/trending`, tag stubs
- ✅ Mobile Feed tabs: For You / Trending / Following
- ✅ Reels full-screen vertical feed
- ✅ Login-gated engagement (like/comment)
- ✅ Stylist onboarding screen & route
- ✅ Tagging UI (MVP)

### October 12, 2025 - AM Session
- ✅ Backend deployed on AWS (port 8006)
- ✅ PostgreSQL database running (Docker)
- ✅ Sample data seeded
- ✅ Mobile app configured
- ✅ Chrome web testing enabled
- ✅ AWS Security Group configured
- ✅ Firebase disabled for web testing

### Next Steps
- [ ] Wire Tag + sheet to backend tagging endpoints
- [ ] Add Follow system and real Following feed
- [ ] Post creation (media upload, caption, tags)
- [ ] Video support in Reels
- [ ] Animations & micro-interactions (double-tap heart, transitions)
- [ ] Implement Firebase auth
- [ ] Stripe payments (future)

---

## 🐛 Known Issues

1. **Firebase disabled for web** - Enabled Chrome testing, need to re-enable for production
2. **HTTP only** - Need HTTPS for production
3. **Mock payments** - Stripe integration pending

---

## 📚 Documentation

- **Project Overview:** [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)
- **Backend Guide:** [BACKEND.md](BACKEND.md)
- **Frontend Guide:** [FRONTEND.md](FRONTEND.md)

---

## 👥 Team & Support

**Repository:** https://github.com/qunexadmin/Zelus  
**Issues:** GitHub Issues  
**Deployment Date:** October 11, 2025

---

## 📝 Version History

### v1.0.0 - October 2025 (Current)
- Initial MVP deployment
- Core booking features
- Mock authentication
- Sample data

---

**Built with ❤️ for beauty professionals and their clients**

