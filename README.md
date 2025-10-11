# Zelux - Stylist-First Beauty Platform

**Zelux** is a modern beauty platform MVP that connects customers with professional stylists. This repository contains both the **FastAPI backend** and **Flutter mobile app** for a complete booking and discovery experience.

## 🎯 Project Overview

Zelux is a stylist-first platform featuring:

- 🔍 **Salon & Stylist Discovery** - Browse and search beauty professionals
- 📅 **Smart Booking System** - Complete appointment booking flow
- 🤖 **AI Style Preview** - Try hairstyles before booking (placeholder)
- 💳 **Payment Integration** - Stripe payment processing (placeholder)
- ⭐ **Reviews & Ratings** - Social proof for stylists and salons
- 📱 **Mobile-First Design** - Beautiful, modern UI

## 🧰 Tech Stack

### Backend
- **Framework**: FastAPI (Python 3.10+)
- **Database**: PostgreSQL with SQLAlchemy ORM
- **Authentication**: Firebase Auth JWT verification
- **API Documentation**: Auto-generated OpenAPI/Swagger docs
- **Deployment**: Docker + Docker Compose ready

### Mobile App
- **Framework**: Flutter 3.0+
- **State Management**: Riverpod
- **Networking**: Dio
- **Navigation**: GoRouter
- **UI**: Material Design 3 with custom theme

### Future Integrations
- **AI Service**: Nano Banana (placeholder endpoints ready)
- **Payments**: Stripe (placeholder endpoints ready)
- **Storage**: Firebase Storage / Cloudinary

## 📁 Project Structure

```
zelux/
├── backend/                    # FastAPI backend
│   ├── app/
│   │   ├── core/              # Configuration & auth
│   │   ├── models/            # SQLAlchemy models
│   │   ├── schemas/           # Pydantic schemas
│   │   ├── routers/           # API endpoints
│   │   ├── db.py              # Database setup
│   │   └── main.py            # FastAPI app
│   ├── alembic/               # Database migrations
│   ├── requirements.txt       # Python dependencies
│   ├── Dockerfile
│   └── env.example            # Environment variables template
│
├── mobile/                     # Flutter mobile app
│   ├── lib/
│   │   ├── core/              # App-wide utilities
│   │   ├── features/          # Feature modules
│   │   └── main.dart          # App entry point
│   ├── pubspec.yaml           # Flutter dependencies
│   └── README.md              # Mobile-specific docs
│
├── docker-compose.yml         # Full stack orchestration
└── README.md                  # This file
```

## 🚀 Quick Start

### Prerequisites

- **Backend**: Python 3.10+, PostgreSQL
- **Mobile**: Flutter 3.0+, Dart 3.0+
- **Docker** (optional but recommended)

### Option 1: Using Docker (Recommended)

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd zelux
   ```

2. **Start the backend with Docker Compose**
   ```bash
   docker-compose up -d
   ```

   This will start:
   - PostgreSQL database on port 5432
   - FastAPI backend on port 8000

3. **Verify backend is running**
   ```bash
   curl http://localhost:8000/health
   ```
   
   Visit API docs: http://localhost:8000/docs

4. **Run the mobile app**
   ```bash
   cd mobile
   flutter pub get
   flutter run
   ```

### Option 2: Manual Setup

#### Backend Setup

1. **Create virtual environment**
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Set up database**
   ```bash
   # Install PostgreSQL and create database
   createdb zelux_db
   
   # Or use the connection string in env.example
   ```

4. **Configure environment**
   ```bash
   cp env.example .env
   # Edit .env with your configuration
   ```

5. **Run migrations**
   ```bash
   alembic upgrade head
   ```

6. **Start the server**
   ```bash
   uvicorn app.main:app --reload
   ```

   Backend will be available at: http://localhost:8000

#### Mobile Setup

1. **Install dependencies**
   ```bash
   cd mobile
   flutter pub get
   ```

2. **Configure API endpoint**
   
   Edit `lib/core/api/api_client.dart`:
   ```dart
   const String kApiBaseUrl = 'http://localhost:8000/api/v1';
   ```
   
   For Android Emulator, use: `http://10.0.2.2:8000/api/v1`

3. **Run the app**
   ```bash
   flutter run
   ```

## 📚 API Documentation

Once the backend is running, access interactive API documentation:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

### Key API Endpoints

#### Authentication
- `POST /api/v1/auth/verify-token` - Verify Firebase token
- `POST /api/v1/auth/register` - Register new user
- `GET /api/v1/auth/me` - Get current user

#### Salons
- `GET /api/v1/salons` - List salons (with pagination & filters)
- `GET /api/v1/salons/{id}` - Get salon details
- `GET /api/v1/salons/{id}/stylists` - Get salon stylists

#### Stylists
- `GET /api/v1/stylists/{id}` - Get stylist profile
- `GET /api/v1/stylists/{id}/services` - Get stylist services
- `GET /api/v1/stylists/{id}/availability` - Check availability

#### Bookings
- `POST /api/v1/bookings` - Create booking
- `GET /api/v1/bookings/{user_id}` - List user bookings
- `GET /api/v1/bookings/details/{id}` - Get booking details
- `PATCH /api/v1/bookings/{id}/cancel` - Cancel booking

#### AI Features (Placeholder)
- `POST /api/v1/ai/preview` - Generate style preview
- `POST /api/v1/ai/style-recommendations` - Get style recommendations
- `GET /api/v1/ai/styles/trending` - Get trending styles

## 🗄️ Database Models

### Core Models
- **User** - Customer and stylist accounts
- **Salon** - Salon/studio locations
- **Stylist** - Professional stylists
- **Service** - Services offered by stylists
- **Booking** - Appointment bookings

### Relationships
- Salons → Stylists (one-to-many)
- Stylists → Services (one-to-many)
- Users → Bookings (one-to-many)
- Stylists → Bookings (one-to-many)

## 🔧 Configuration

### Backend Environment Variables

Create a `.env` file in the `backend/` directory:

```env
# Database
DATABASE_URL=postgresql://zelux_user:zelux_password@localhost:5432/zelux_db

# Security
SECRET_KEY=your-secret-key-change-in-production
ALGORITHM=HS256

# Firebase (Optional - for production)
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key

# CORS
BACKEND_CORS_ORIGINS=["http://localhost:3000","http://localhost:8080"]

# AI Service (Future)
AI_SERVICE_URL=https://api.nanobanana.example.com
AI_SERVICE_API_KEY=your-ai-api-key

# Payments (Future)
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key
STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_publishable_key
```

## 🧪 Testing

### Backend Tests
```bash
cd backend
pytest
```

### Mobile Tests
```bash
cd mobile
flutter test
```

## 📦 Deployment

### Backend Deployment

#### Using Docker
```bash
docker build -t zelux-backend ./backend
docker run -p 8000:8000 -e DATABASE_URL=your-db-url zelux-backend
```

#### Using Cloud Platforms
- **Railway**: Connect repo, set environment variables
- **Heroku**: Use provided Dockerfile
- **AWS/GCP**: Deploy with Docker or direct Python runtime

### Mobile Deployment

#### iOS
```bash
cd mobile
flutter build ios --release
# Use Xcode to submit to App Store
```

#### Android
```bash
cd mobile
flutter build appbundle --release
# Upload to Google Play Console
```

## 🔒 Security Notes

⚠️ **Important for Production:**

1. **Change default secrets** in `.env` file
2. **Enable Firebase authentication** properly
3. **Set up HTTPS** with valid SSL certificates
4. **Configure CORS** with specific origins only
5. **Use environment variables** for all sensitive data
6. **Enable rate limiting** on API endpoints
7. **Implement proper input validation**
8. **Set up database backups**

## 🎨 Features & Screens

### Mobile App Screens

1. **Login Screen** - Email/password authentication
2. **Home/Discover** - Browse salons and stylists
3. **Salon Detail** - View salon info and stylists
4. **Stylist Profile** - Portfolio, reviews, specialties
5. **Booking Flow** - Multi-step booking process
6. **My Bookings** - View appointments
7. **AI Preview** - Try styles with AI
8. **Profile** - User settings and preferences

## 📝 Development Workflow

### Backend Development
```bash
# Create new migration
alembic revision --autogenerate -m "description"

# Apply migrations
alembic upgrade head

# Rollback migration
alembic downgrade -1

# Format code
black app/
```

### Mobile Development
```bash
# Code generation
flutter pub run build_runner build

# Analyze code
flutter analyze

# Format code
flutter format lib/
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

Copyright © 2025 Zelux. All rights reserved.

## 🔮 Roadmap

### Phase 1 (MVP) ✅
- [x] Basic authentication
- [x] Salon/stylist discovery
- [x] Booking system
- [x] Mobile app UI

### Phase 2 (Coming Soon)
- [ ] Real Firebase integration
- [ ] Stripe payment processing
- [ ] AI style preview integration (Nano Banana)
- [ ] Push notifications
- [ ] In-app chat

### Phase 3 (Future)
- [ ] Admin dashboard
- [ ] Analytics & reporting
- [ ] Loyalty programs
- [ ] Multi-location support
- [ ] Advanced AI features

## 📧 Support

For questions or support, please open an issue on GitHub.

---

**Built with ❤️ for beauty professionals and their clients**

