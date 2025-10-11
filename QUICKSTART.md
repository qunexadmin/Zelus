# 🚀 Zelux Quick Start Guide

Get your Zelux MVP up and running in minutes!

## ⚡ Fastest Way to Start

### 1. Start Backend with Docker (30 seconds)

```bash
# From project root
docker-compose up -d

# Wait a few seconds, then verify
curl http://localhost:8000/health
```

✅ **Backend running at**: http://localhost:8000  
📚 **API Docs**: http://localhost:8000/docs

### 2. Seed Sample Data (Optional but Recommended)

```bash
cd backend
python seed_data.py
```

This creates:
- 3 sample salons
- 4 stylists with portfolios
- 7 services
- 3 sample bookings
- 3 test users

### 3. Start Mobile App (1 minute)

```bash
cd mobile
flutter pub get
flutter run
```

**Demo Login Credentials:**
- Email: `demo@zelux.com`
- Password: `anything` (mock login for development)

---

## 📱 Testing the Flow

### 1. Login Screen
- Enter any email/password (Firebase not required for development)
- Or click "Continue" to use mock authentication

### 2. Discover Tab
- Browse featured salons
- Tap any salon to view details
- Click on stylists to see their profiles

### 3. Book an Appointment
- From a stylist profile, click "Book Appointment"
- Select service → Pick date → Choose time → Confirm
- View booking in "Bookings" tab

### 4. AI Preview (Placeholder)
- Tap the ✨ icon in top right
- Upload a photo from gallery or take one
- Click "Generate Previews" to see mock AI results

---

## 🔧 API Quick Reference

All endpoints are prefixed with `/api/v1`

### Test Endpoints

```bash
# Health check
curl http://localhost:8000/health

# List salons
curl http://localhost:8000/api/v1/salons

# Get specific salon
curl http://localhost:8000/api/v1/salons/salon-1

# Get stylist
curl http://localhost:8000/api/v1/stylists/stylist-1

# Register user (for testing without Firebase)
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","name":"Test User"}'
```

---

## 🎯 Key Features to Test

### ✅ Working Features
- [x] User authentication (mock)
- [x] Salon discovery & search
- [x] Stylist profiles with portfolios
- [x] Complete booking flow
- [x] View bookings
- [x] AI preview UI (mock data)

### 🚧 TODO Placeholders
- [ ] Firebase authentication (commented, ready to enable)
- [ ] Stripe payment processing (placeholder)
- [ ] AI service integration (mock endpoint ready)
- [ ] Push notifications
- [ ] Real-time chat

---

## 🐛 Troubleshooting

### Backend won't start
```bash
# Check if port 8000 is in use
lsof -i :8000  # Mac/Linux
netstat -ano | findstr :8000  # Windows

# Restart containers
docker-compose down
docker-compose up -d
```

### Database errors
```bash
# Reset database
docker-compose down -v
docker-compose up -d
cd backend
python seed_data.py
```

### Mobile app can't connect to backend

**iOS Simulator**: Use `http://localhost:8000/api/v1`

**Android Emulator**: Use `http://10.0.2.2:8000/api/v1`

**Physical Device**: Use your computer's IP
```bash
# Find your IP
ipconfig getifaddr en0  # Mac
hostname -I  # Linux
ipconfig  # Windows

# Update in mobile/lib/core/api/api_client.dart
const String kApiBaseUrl = 'http://YOUR_IP:8000/api/v1';
```

### Flutter build errors
```bash
cd mobile
flutter clean
flutter pub get
flutter run
```

---

## 📊 Project Status

### ✅ Completed MVP Features
- Complete backend API with FastAPI
- PostgreSQL database with migrations
- Pydantic schemas for validation
- RESTful API endpoints
- Docker deployment ready
- Flutter mobile app with 8+ screens
- Beautiful Material Design 3 UI
- State management with Riverpod
- Complete booking flow
- Mock authentication

### 🎯 Next Steps for Production

1. **Enable Firebase Auth**
   ```dart
   // Uncomment in mobile/lib/main.dart
   await Firebase.initializeApp();
   ```

2. **Add Stripe Payments**
   - Backend: Implement in `routers/bookings.py`
   - Mobile: Add payment sheet in `BookingFlowScreen`

3. **Integrate AI Service**
   - Update `routers/ai.py` with real API calls
   - Connect to Nano Banana or similar service

4. **Deploy Backend**
   - Railway, Heroku, or AWS
   - Update environment variables
   - Set up SSL

5. **Publish Mobile App**
   - Configure Firebase for production
   - Build release versions
   - Submit to App Store / Play Store

---

## 📚 Documentation

- **Main README**: [README.md](README.md)
- **Backend Details**: [backend/README.md](backend/README.md)
- **Mobile Details**: [mobile/README.md](mobile/README.md)
- **API Docs**: http://localhost:8000/docs (when running)

---

## 💡 Development Tips

### Hot Reload
- **Backend**: Automatic with `--reload` flag
- **Mobile**: Press `r` in terminal or save files

### Database Changes
```bash
cd backend
alembic revision --autogenerate -m "description"
alembic upgrade head
```

### Add New Endpoint
1. Create route in `backend/app/routers/`
2. Add to `main.py` with `app.include_router()`
3. Test at http://localhost:8000/docs

### Add New Screen
1. Create in `mobile/lib/features/*/presentation/screens/`
2. Add route in `lib/core/router/app_router.dart`
3. Navigate with `context.push('/route-name')`

---

## 🎉 You're Ready!

Your Zelux MVP is fully functional. Start exploring, make it your own, and build something amazing!

**Questions?** Check the main README or open an issue on GitHub.

---

Made with ❤️ for beauty professionals and their clients

