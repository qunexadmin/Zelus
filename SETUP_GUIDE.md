# 🚀 ZELUX COMPLETE SETUP GUIDE

**Complete Backend + Mobile App Deployment**

---

## 📋 QUICK OVERVIEW

You have 2 parts:
- **Backend (FastAPI)** - Runs on AWS Ubuntu server (Port 8000)
- **Mobile App (Flutter)** - Runs on your Windows/Mac laptop

---

## ✅ PART 1: BACKEND ON AWS (COMPLETED ✓)

### Backend Status:
- ✅ PostgreSQL Database: Running (Docker)
- ✅ Python Environment: Setup complete
- ✅ Dependencies: Installed
- ✅ Database: Initialized with sample data
- ✅ FastAPI Server: Running on port 8000
- ✅ Mobile API URL: Configured to `http://3.24.31.8:8000`

### What Was Done:

1. **Created `.env` file** with database configuration
2. **Started PostgreSQL** database in Docker container
3. **Created Python virtual environment** (`venv`)
4. **Installed all dependencies** from `requirements.txt`
5. **Seeded database** with sample data:
   - 3 users (demo@zelux.com)
   - 3 salons (Elite Hair Studio, Color Studio NYC, Downtown Barbers)
   - 4 stylists (Jane Smith, Michael Chen, Sarah Johnson, Mike Brown)
   - 7 services (haircuts, color, balayage, etc.)
   - 3 sample bookings
6. **Started FastAPI server** on `0.0.0.0:8000`

### Backend URLs:
- **Health Check**: http://3.24.31.8:8000/health
- **API Docs (Swagger)**: http://3.24.31.8:8000/docs
- **API Root**: http://3.24.31.8:8000/api/v1

---

## 🔓 STEP 1: OPEN PORT IN AWS SECURITY GROUP

**CRITICAL: You MUST do this before the mobile app can connect!**

1. Go to **AWS Console** → **EC2** → **Security Groups**
2. Select your instance's security group
3. Click **Inbound Rules** → **Edit Inbound Rules**
4. Click **Add Rule** and configure:
   ```
   Type:        Custom TCP
   Port:        8000
   Source:      0.0.0.0/0  (or your IP for security)
   Description: Zelux FastAPI Backend
   ```
5. Click **Save Rules**

### Verify Port is Open:
```bash
# From your laptop, test the connection:
curl http://3.24.31.8:8000/health

# Expected response:
# {"status":"healthy","service":"zelux-api"}
```

---

## 📱 PART 2: MOBILE APP SETUP (YOUR LAPTOP)

### 🔽 STEP 1: Install Flutter

#### For Windows:

1. **Download Flutter SDK**:
   - Go to: https://docs.flutter.dev/get-started/install/windows
   - Download "Flutter SDK" (latest stable)
   - Extract to: `C:\src\flutter` (or any folder)

2. **Add to PATH**:
   - Search "Environment Variables" in Windows
   - Edit "Path" variable
   - Add: `C:\src\flutter\bin`
   - Click OK
   - **Restart PowerShell/Terminal**

3. **Verify installation**:
   ```powershell
   flutter --version
   flutter doctor
   ```

#### For Mac:

1. **Download Flutter SDK**:
   ```bash
   cd ~/development
   curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.x.x-stable.zip
   unzip flutter_macos_3.x.x-stable.zip
   ```

2. **Add to PATH**:
   ```bash
   echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
   source ~/.zshrc
   ```

3. **Verify installation**:
   ```bash
   flutter --version
   flutter doctor
   ```

---

### 📱 STEP 2: Setup Android/iOS

#### For Android (easier, works on Windows/Mac/Linux):

1. **Install Android Studio**: https://developer.android.com/studio
2. During install, include:
   - Android SDK
   - Android SDK Platform Tools
   - Android Virtual Device (AVD)

3. **Create Virtual Device**:
   - Open Android Studio
   - Go to: **Tools** → **Device Manager**
   - Click **Create Device**
   - Choose **Pixel 6** or any modern phone
   - Download system image (API 33 recommended)
   - Click **Finish**

4. **Start Emulator**:
   - Click ▶️ (Play button) next to your device
   - Wait for emulator to boot (takes 1-2 minutes first time)

5. **Verify Flutter can see device**:
   ```bash
   flutter devices
   # Should show your emulator
   ```

#### For iOS (Mac only):

1. **Install Xcode** from App Store (takes a while)

2. **Setup Xcode**:
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```

3. **Install CocoaPods**:
   ```bash
   sudo gem install cocoapods
   ```

4. **Open iOS Simulator**:
   ```bash
   open -a Simulator
   ```

---

### 📦 STEP 3: Install Flutter Dependencies

Navigate to the mobile app directory and install dependencies:

```bash
cd /path/to/Zelus/mobile
flutter pub get
```

**Note**: If you're on your Windows laptop, you'll need to:
1. Download the Zelus project to your laptop (from GitHub or copy files)
2. Navigate to the `mobile` folder
3. Run `flutter pub get`

---

### 🚀 STEP 4: Run the Mobile App

1. **Make sure emulator/simulator is running**
2. **Run the app**:
   ```bash
   cd mobile
   flutter run
   ```

3. **First build takes 2-5 minutes** (subsequent runs are faster with hot reload)

4. **Select your device** if prompted (choose Android emulator or iOS simulator)

---

### ✅ STEP 5: Test the Complete Flow

1. **Login Screen** appears
   - Email: `demo@zelux.com` (or any email)
   - Password: `anything` (mock auth for development)
   - Click **Sign In**

2. **Discover Tab** - Browse salons
   - See list of 3 salons
   - Tap **Elite Hair Studio**

3. **Salon Detail** - View salon info
   - See services and stylists
   - Tap **Jane Smith**

4. **Stylist Profile** - View stylist details
   - See portfolio, reviews, ratings
   - Click **Book Appointment**

5. **Booking Flow** - Complete booking
   - Select service → Pick date → Choose time → Confirm

6. **Bookings Tab** - View your bookings
   - See your new booking in the list

7. **AI Preview** (Placeholder)
   - Tap ✨ icon in top right
   - Upload photo from gallery
   - Click "Generate Previews" (shows mock data)

---

## 🎯 BACKEND MANAGEMENT

### Check Backend Status:
```bash
# On AWS server
ps aux | grep uvicorn

# Test API health
curl http://localhost:8000/health
```

### Stop Backend:
```bash
pkill -f "uvicorn app.main:app"
```

### Start Backend:
```bash
cd /home/ubuntu/Zelus/backend
source venv/bin/activate
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload &
```

### View Backend Logs:
```bash
# If running in background, check process
ps aux | grep uvicorn

# Or run in foreground to see logs
cd /home/ubuntu/Zelus/backend
source venv/bin/activate
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

### Restart Backend:
```bash
pkill -f "uvicorn app.main:app"
cd /home/ubuntu/Zelus/backend
source venv/bin/activate
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload &
```

---

## 🐛 TROUBLESHOOTING

### Backend Issues:

#### ❌ Can't connect to backend from mobile app
**Solution:**
1. Verify AWS Security Group has port 8000 open
2. Test from laptop: `curl http://3.24.31.8:8000/health`
3. Check backend is running: `ps aux | grep uvicorn`
4. Verify you're using PUBLIC IP (not localhost)

#### ❌ Port 8000 already in use
**Solution:**
```bash
# Find process using port 8000
sudo lsof -i :8000

# Kill the process
pkill -f "uvicorn"
# or
kill <PID>
```

#### ❌ Database connection errors
**Solution:**
```bash
# Check if PostgreSQL container is running
docker ps | grep zelux-db

# Restart database
cd /home/ubuntu/Zelus
docker compose restart db

# If that fails, recreate database
docker compose down -v
docker compose up -d db
cd backend
source venv/bin/activate
python seed_data.py
```

#### ❌ Module not found errors
**Solution:**
```bash
cd /home/ubuntu/Zelus/backend
source venv/bin/activate
pip install -r requirements.txt
pip install pydantic[email]  # If email-validator error
```

---

### Mobile App Issues:

#### ❌ Flutter command not found
**Solution:**
- Restart terminal after installing Flutter
- Verify Flutter is in PATH: `echo $PATH` (Mac/Linux) or `$env:Path` (Windows)
- Re-add Flutter to PATH

#### ❌ No devices found
**Solution:**
```bash
# Check available devices
flutter devices

# For Android: Start emulator from Android Studio
# For iOS: Open Simulator app

# Then run again
flutter run
```

#### ❌ Can't connect to API (network error)
**Solution:**
1. Check AWS security group has port 8000 open
2. Verify backend is running: `curl http://3.24.31.8:8000/health`
3. Make sure mobile app is using PUBLIC IP (check `lib/core/api/api_client.dart`)
4. For Android emulator, you might need to use `10.0.2.2` instead of `localhost`

#### ❌ Build errors
**Solution:**
```bash
cd mobile
flutter clean
flutter pub get
flutter run
```

#### ❌ Gradle build errors (Android)
**Solution:**
```bash
cd mobile/android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

---

## 📚 API ENDPOINTS

All endpoints are prefixed with `/api/v1`

### Test Endpoints:

```bash
# Health check
curl http://3.24.31.8:8000/health

# List salons
curl http://3.24.31.8:8000/api/v1/salons

# Get specific salon
curl http://3.24.31.8:8000/api/v1/salons/salon-1

# Get stylist
curl http://3.24.31.8:8000/api/v1/stylists/stylist-1

# Get services for a stylist
curl http://3.24.31.8:8000/api/v1/stylists/stylist-1/services

# Register user (for testing)
curl -X POST http://3.24.31.8:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","name":"Test User"}'
```

### Interactive API Docs:
Open in browser: http://3.24.31.8:8000/docs

---

## 🎉 SUCCESS CHECKLIST

### Backend:
- [ ] `.env` file configured ✅
- [ ] PostgreSQL database running ✅
- [ ] Python dependencies installed ✅
- [ ] Database initialized ✅
- [ ] Sample data loaded ✅
- [ ] Server running on port 8000 ✅
- [ ] AWS Security Group port 8000 open ⚠️ **YOU NEED TO DO THIS**
- [ ] Health endpoint accessible from laptop

### Mobile:
- [ ] Flutter installed
- [ ] Android Studio installed (or Xcode for Mac)
- [ ] Emulator/Simulator running
- [ ] API URL updated to `http://3.24.31.8:8000/api/v1` ✅
- [ ] Dependencies installed (`flutter pub get`)
- [ ] App runs successfully
- [ ] Can see salons in Discover tab
- [ ] Can complete booking flow

---

## 📊 SAMPLE DATA

### Users:
- `demo@zelux.com` - Demo User
- `customer1@example.com` - Alice Johnson
- `customer2@example.com` - Bob Smith

### Salons:
1. **Elite Hair Studio** (NYC) - Jane Smith, Michael Chen
2. **Color Studio NYC** - Sarah Johnson
3. **Downtown Barbers** - Mike Brown

### Test Booking Flow:
1. Login with `demo@zelux.com`
2. Browse salons → Tap "Elite Hair Studio"
3. Select stylist "Jane Smith"
4. Book "Women's Haircut & Style" ($75)
5. Choose date and time
6. Confirm booking
7. See booking in "Bookings" tab

---

## 🔄 QUICK COMMAND REFERENCE

### Backend (AWS Server):
```bash
# Navigate to backend
cd /home/ubuntu/Zelus/backend

# Activate virtual environment
source venv/bin/activate

# Start server
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

# Stop server
pkill -f "uvicorn app.main:app"

# Check if running
ps aux | grep uvicorn

# Test API
curl http://localhost:8000/health

# Restart database
cd /home/ubuntu/Zelus
docker compose restart db

# Reseed database
cd backend
source venv/bin/activate
python seed_data.py
```

### Mobile (Your Laptop):
```bash
# Navigate to mobile app
cd /path/to/Zelus/mobile

# Install dependencies
flutter pub get

# Check devices
flutter devices

# Run app
flutter run

# Hot reload (while app is running)
# Press 'r' in terminal

# Clean build
flutter clean
flutter pub get
flutter run
```

---

## 📞 SUPPORT

### View API Documentation:
- http://3.24.31.8:8000/docs (after opening port 8000)

### Test Backend Connection:
```bash
curl http://3.24.31.8:8000/health
```

### Check Flutter Setup:
```bash
flutter doctor -v
```

---

## 🎊 YOU'RE READY!

Your Zelux MVP is fully set up! 

**Next Steps:**
1. ⚠️ **Open port 8000 in AWS Security Group** (required!)
2. Install Flutter on your laptop
3. Setup Android emulator or iOS simulator
4. Run the mobile app
5. Start testing!

**Questions?** Check the troubleshooting section or run `flutter doctor` for mobile issues.

---

Made with ❤️ for beauty professionals and their clients

**Project Structure:**
- Backend: `/home/ubuntu/Zelus/backend`
- Mobile: `/home/ubuntu/Zelus/mobile`
- This Guide: `/home/ubuntu/Zelus/SETUP_GUIDE.md`

**AWS Server IP:** `3.24.31.8`
**Backend Port:** `8000`


