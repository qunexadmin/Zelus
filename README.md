# 🎨 Zelux - Beauty Pro Network

**A modern beauty discovery & booking platform with AI-powered features and social content**

**Version:** v1.4.0 - Retail & Product Discovery! 🛍️

---

## 🚀 Quick Start (Phase 1 MVP)

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

**Login:** Enter any email/phone (fields are optional for development)

### What you'll see (October 17 Update)
- **Elegant Login Page** - Sophisticated charcoal & muted gold design
- **4-Tab Navigation** - Home, **Explore**, Saved, Profile (cleaner!)
- **Discover Tab** - Dynamic greeting, AI insights, trending styles
- **Explore Tab** - Professionals | Salons | **Retail** (all discovery unified)
  - Browse pros with advanced filters
  - Find salons near you
  - Discover beauty products with price tracking
- **Profile Tab** - Stats section with refined menu
- **Clean Codebase** - Simplified folder structure, easy to navigate
- **Haptic Feedback** - Enhanced touch interactions
- **Pull-to-Refresh** - On all major screens

---

## 📚 Documentation

📋 **[PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)** - Project status, architecture, features  
🔧 **[BACKEND.md](BACKEND.md)** - Backend setup, API docs, database  
📱 **[mobile/README.md](mobile/README.md)** - Mobile app: setup, features, testing & integration

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

- 🎨 **Sophisticated Design System** - Charcoal & muted gold palette with light typography
- 🔍 **Salon & Stylist Discovery** - Advanced filters and elegant UI
- 🛍️ **Retail & Product Discovery** - AI-powered product search with price tracking & deals
- 📅 **Complete Booking System** - External booking links to salons
- 👤 **User Authentication** - Mock (email/phone optional for dev)
- ⭐ **Reviews & Ratings** - AI-powered summaries
- 📱 **Beautiful Material Design 3 UI** - Consistent, minimalist, luxurious

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

## 🧪 Test the Flow (Updated October 17)

1. Run mobile app: `flutter run -d chrome`
2. **Login page** - Enter any email/phone (or leave blank) → Tap "Sign In"
3. **Home Tab** - See dynamic greeting, AI insights, trending styles
4. **Explore Tab** - Unified discovery with 3 tabs:
   - **Professionals** - Browse with filters (city, service, rating)
   - **Salons** - Find locations near you
   - **Retail** - Discover products, track prices, view deals
     - AI recommendations based on your visits
     - Track products on watchlist
     - Hot deals & price drop alerts
5. **Saved Tab** - View and organize collections
6. **Profile Tab** - View stats, access account settings
7. **Tap any pro** - View profile, portfolio, reviews → Contact/Book

---

## 📞 Support

**Repository:** https://github.com/qunexadmin/Zelus  
**Issues:** GitHub Issues  
**Last Updated:** October 17, 2025

---

**Built with ❤️ for beauty professionals and their clients**
