# 🎨 Zelux - Stylist-First Beauty Platform

**A modern beauty booking platform connecting customers with professional stylists**

---

## 🚀 Quick Start (Social-First MVP)

### Prerequisites
- **Backend:** Python 3.10+, Docker
- **Frontend:** Flutter 3.0+

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
flutter run -d chrome  # or android/ios
```

**Login:** `demo@zelux.com` / `any password`

### What you'll see
- Feed tab with For You / Trending / Following
- Reels (tap play icon in Feed app bar)
- Like/Comment prompts login
- “Become a Stylist” → onboarding form

---

## 📚 Documentation

📋 **[PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)** - Project status, architecture, features  
🔧 **[BACKEND.md](BACKEND.md)** - Backend setup, API docs, database  
📱 **[FRONTEND.md](FRONTEND.md)** - Mobile app setup, screens, development

---

## 🏗️ Architecture

```
Flutter App (Mobile/Web) → FastAPI Backend (Port 8006) → PostgreSQL (Docker)
```

**API:** http://3.24.31.8:8006/api/v1  
**Docs:** http://3.24.31.8:8006/docs

Feed endpoints:
- For You: `GET /api/v1/feed`
- Trending: `GET /api/v1/feed/trending`
- Tagging (MVP):
  - `POST /api/v1/feed/{post_id}/tag-salon?salon_id=...`
  - `POST /api/v1/feed/{post_id}/tag-stylist?stylist_id=...`

---

## ✅ Current Status

- ✅ Backend deployed on AWS (3.24.31.8:8006)
- ✅ PostgreSQL database running
- ✅ Sample data loaded
- ✅ Mobile app ready for testing
- ✅ Chrome web testing enabled

---

## 🎯 Key Features

- 🔍 Salon & Stylist Discovery
- 📅 Complete Booking System
- 👤 User Authentication (Mock)
- ⭐ Reviews & Ratings
- 📱 Beautiful Material Design 3 UI

---

## 🛠️ Tech Stack

**Backend:** FastAPI, PostgreSQL, SQLAlchemy  
**Frontend:** Flutter, Dart, Riverpod  
**Infrastructure:** AWS EC2, Docker

---

## 📦 Sample Data

- **Salons:** Elite Hair Studio, Color Studio NYC, Downtown Barbers
- **Stylists:** Jane Smith, Michael Chen, Sarah Johnson, Mike Brown
- **Services:** Haircuts ($45-$75), Color ($150-$250), Balayage ($200)

---

## 🧪 Test the Flow

1. Run mobile app: `flutter run -d chrome`
2. Login: `demo@zelux.com`
3. Browse salons → Select "Elite Hair Studio"
4. Choose stylist → "Jane Smith"
5. Book appointment → Complete flow
6. View booking in "My Bookings"

---

## 📞 Support

**Repository:** https://github.com/qunexadmin/Zelus  
**Issues:** GitHub Issues  
**Last Updated:** October 12, 2025

---

**Built with ❤️ for beauty professionals and their clients**
