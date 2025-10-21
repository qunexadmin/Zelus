# 🎨 Zelus - Beauty Platform

**Modern beauty booking platform connecting customers with professional stylists**

[![Status](https://img.shields.io/badge/status-production-success.svg)]()
[![Database](https://img.shields.io/badge/database-neon-blue.svg)]()
[![Integration](https://img.shields.io/badge/mobile-integrated-green.svg)]()

---

## 📖 Documentation

- 📊 **[PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)** - Complete project documentation
- 🔧 **[BACKEND.md](BACKEND.md)** - Backend setup and API documentation

---

## 🚀 Quick Start

**Start Backend:**
```bash
cd backend && source venv/bin/activate
uvicorn app.main:app --host 0.0.0.0 --port 8006 --reload
```

**Start Mobile:**
```bash
cd mobile && flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d chrome
```

**API Docs:** http://3.24.31.8:8006/docs

---

## 📊 Status

**Version:** 1.5.5 (Backend Integration Complete)  
**Database:** Neon PostgreSQL 17.5 - zelus  
**Integration:** ✅ Mobile app fully connected  
**Data:** 3 salons • 4 stylists • 7 services

---

## 🏗️ Architecture

```
Flutter App ──HTTP──> FastAPI Backend ──SSL──> Neon PostgreSQL
 (Mobile)              (AWS EC2)              (Serverless)
```

---

**Built with ❤️ for beauty professionals and their clients**

*Last Updated: October 20, 2025*

