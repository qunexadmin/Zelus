# 🎨 Zelus - Beauty Platform

> A modern, serverless beauty booking platform connecting customers with professional stylists

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![Database](https://img.shields.io/badge/database-neon-blue.svg)]()
[![API](https://img.shields.io/badge/api-fastapi-green.svg)]()

---

## 📖 Quick Links

- 📊 **[Project Overview](PROJECT_OVERVIEW.md)** - Complete project documentation
- 🔧 **[Backend Guide](BACKEND.md)** - Backend setup and API documentation
- 🌐 **API Docs:** http://3.24.31.8:8006/docs

---

## 🚀 Quick Start

### Backend (FastAPI + Neon PostgreSQL)
```bash
cd backend
source venv/bin/activate
uvicorn app.main:app --host 0.0.0.0 --port 8006 --reload
```

### Mobile (Flutter)
```bash
cd mobile
flutter pub get
flutter run -d chrome
```

---

## 🏗️ Architecture

```
Flutter App ──HTTP──> FastAPI Backend ──SSL──> Neon PostgreSQL
 (Mobile)              (AWS EC2)              (Serverless)
```

---

## 🎯 Key Features

- 🔍 **Salon & Stylist Discovery** - Browse and search professionals
- ⭐ **Reviews & Ratings** - Social proof system
- 🤝 **Social Features** - Follow system & activity feed
- 💬 **Messaging** - Direct chat + AI assistant
- 🛍️ **Product Discovery** - AI-powered beauty product search
- 📱 **Mobile-First UI** - Beautiful Material Design 3

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Flutter 3.x, Dart, Riverpod, GoRouter |
| **Backend** | FastAPI, Python 3.10, SQLAlchemy 2.0 |
| **Database** | Neon PostgreSQL 17.5 (Serverless) |
| **Hosting** | AWS EC2 (Backend), Neon Cloud (Database) |
| **Migrations** | Alembic |

---

## 📂 Project Structure

```
Zelus/
├── backend/              # FastAPI backend
│   ├── app/             # Application code
│   ├── alembic/         # Database migrations
│   └── requirements.txt # Dependencies
├── mobile/              # Flutter app
│   ├── lib/            # Dart code
│   └── pubspec.yaml    # Flutter dependencies
├── PROJECT_OVERVIEW.md  # Full documentation
└── BACKEND.md          # Backend guide
```

---

## 🗄️ Database (Neon PostgreSQL)

**Why Neon?**
- ✅ Serverless PostgreSQL (auto-scaling)
- ✅ Automatic backups & point-in-time recovery
- ✅ Database branching for dev/staging
- ✅ Connection pooling built-in
- ✅ Pay-per-use pricing

**Alembic Migrations:**
```bash
# Create migration after model changes
alembic revision --autogenerate -m "description"

# Apply migrations
alembic upgrade head

# Rollback if needed
alembic downgrade -1
```

---

## 📊 Current Status

| Metric | Value |
|--------|-------|
| **Version** | 1.5.1 (Clean Architecture) |
| **Database** | Neon PostgreSQL 17.5 - zelus |
| **API Status** | ✅ Running (port 8006) |
| **Tables** | 4 (users, salons, stylists, services) |
| **Sample Data** | 3 users, 3 salons, 4 stylists, 7 services |

---

## 🧪 API Testing

```bash
# Health check
curl http://3.24.31.8:8006/health

# List salons
curl http://3.24.31.8:8006/api/v1/salons

# Get specific salon
curl http://3.24.31.8:8006/api/v1/salons/salon-1
```

**Interactive Docs:** http://3.24.31.8:8006/docs

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) | Complete project documentation, architecture, features |
| [BACKEND.md](BACKEND.md) | Backend setup, API endpoints, database management |
| README.md (this file) | Quick start guide and overview |

---

## 🔐 Environment Setup

Create `backend/.env`:
```bash
DATABASE_URL=postgresql://user:pass@hostname.neon.tech/zelus?sslmode=require
SECRET_KEY=your-secret-key
API_V1_STR=/api/v1
PROJECT_NAME=Zelux API
```

See `backend/env.example` for complete configuration.

---

## 🐛 Troubleshooting

**Backend won't start:**
```bash
# Check Python version
python3 --version  # Should be 3.10+

# Reinstall dependencies
cd backend
source venv/bin/activate
pip install -r requirements.txt
```

**Database connection error:**
```bash
# Test connection
cd backend
source venv/bin/activate
python -c "from app.db import engine; engine.connect(); print('✅ Connected')"
```

**Port already in use:**
```bash
# Find and kill process on port 8006
sudo lsof -i :8006
pkill -f "uvicorn"
```

---

## 📈 Deployment

**Backend (Current):**
- Server: AWS EC2 (3.24.31.8)
- Port: 8006
- Process: Direct uvicorn (no Docker)

**Database (Current):**
- Provider: Neon (https://neon.tech)
- Database Name: zelus
- Region: AWS ap-southeast-1
- Type: Serverless PostgreSQL 17.5

---

## 🤝 Contributing

1. Make changes to your feature branch
2. Update documentation if needed
3. Test locally
4. Create pull request

---

## 📞 Support

- **Repository:** https://github.com/qunexadmin/Zelus
- **Issues:** GitHub Issues
- **API Docs:** http://3.24.31.8:8006/docs
- **Neon Console:** https://console.neon.tech

---

## 📝 Version History

### v1.5.1 - October 18, 2025 (Current)
- 🧹 Project cleanup & restructuring
- 🗄️ Migrated to Neon PostgreSQL
- 📚 Simplified documentation (2 core docs)
- ✅ Removed Docker dependencies

### v1.5.0 - October 18, 2025
- 🤝 Social features (follow system, activity feed)
- 💬 Messaging & AI assistant
- 🎨 Enhanced UI/UX

---

**Built with ❤️ for beauty professionals and their clients**

*Last Updated: October 18, 2025*

