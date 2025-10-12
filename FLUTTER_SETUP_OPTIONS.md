# 📱 FLUTTER SETUP OPTIONS

## ✅ BACKEND UPDATE COMPLETE

**Backend is now running on PORT 8006** (instead of 8000)

- **Server IP:** 3.24.31.8
- **Port:** 8006
- **API URL:** http://3.24.31.8:8006/api/v1
- **Health Check:** http://3.24.31.8:8006/health
- **API Docs:** http://3.24.31.8:8006/docs

**Mobile app has been updated to use port 8006 automatically!**

---

## 🎯 TWO OPTIONS TO RUN FLUTTER MOBILE APP

### **OPTION 1: Keep Code on Server + Flutter on Laptop** (Recommended)

Yes, you can **keep the mobile code on the server** and run Flutter from your laptop!

#### How it works:
1. Mobile code stays on AWS server at `/home/ubuntu/Zelus/mobile`
2. You install Flutter on your Windows/Mac laptop
3. You copy/sync just the mobile folder to your laptop
4. You run Flutter from your laptop

#### Steps:

**1. Copy Mobile Code to Your Laptop**

From your Windows laptop:
```powershell
# Option A: Using SCP (if you have OpenSSH)
scp -r ubuntu@3.24.31.8:/home/ubuntu/Zelus/mobile C:\Projects\Zelus\mobile

# Option B: Using WinSCP (GUI tool)
# Download from: https://winscp.net/
# Connect to: 3.24.31.8
# Copy folder: /home/ubuntu/Zelus/mobile → Your local directory
```

From your Mac laptop:
```bash
# Using SCP
scp -r ubuntu@3.24.31.8:/home/ubuntu/Zelus/mobile ~/Projects/Zelus/mobile

# Or use rsync (better for updates)
rsync -avz ubuntu@3.24.31.8:/home/ubuntu/Zelus/mobile/ ~/Projects/Zelus/mobile/
```

**2. Install Flutter on Your Laptop**

- **Windows:** https://docs.flutter.dev/get-started/install/windows
- **Mac:** https://docs.flutter.dev/get-started/install/macos

Verify:
```bash
flutter --version
flutter doctor
```

**3. Setup Emulator**

**Android (Windows/Mac/Linux):**
- Install Android Studio
- Create virtual device (Pixel 6)
- Start emulator

**iOS (Mac only):**
- Install Xcode
- Open Simulator

**4. Run the App**

```bash
cd /path/to/Zelus/mobile
flutter pub get
flutter run
```

**5. When You Update Code on Server**

Just sync the files again:
```bash
# Mac/Linux
rsync -avz ubuntu@3.24.31.8:/home/ubuntu/Zelus/mobile/ ~/Projects/Zelus/mobile/

# Windows (WinSCP or manual copy)
scp -r ubuntu@3.24.31.8:/home/ubuntu/Zelus/mobile C:\Projects\Zelus\mobile
```

---

### **OPTION 2: Run Everything Locally**

If you prefer, you can also:
1. Clone the entire Zelus project to your laptop
2. Keep your own local copy
3. Make changes locally
4. Push to Git when ready

#### Steps:
```bash
# On your laptop
git clone <your-repo-url>
cd Zelus/mobile
flutter pub get
flutter run
```

---

## 🔑 IMPORTANT: API Configuration

The mobile app is **already configured** to use your AWS backend:

**File:** `mobile/lib/core/api/api_client.dart`
```dart
const String kApiBaseUrl = 'http://3.24.31.8:8006/api/v1';
```

This means:
- ✅ Mobile app will connect to AWS backend (port 8006)
- ✅ No need to run backend on your laptop
- ✅ Just run Flutter and it will connect to server

**Before the app will connect, you MUST:**
1. Open port 8006 in AWS Security Group
2. Test: `curl http://3.24.31.8:8006/health`

---

## 📊 WORKFLOW COMPARISON

### Option 1: Code on Server
```
[AWS Server] → [Your Laptop]
   Backend         Flutter
   Database        Emulator
   Mobile Code     Mobile App Runs
```

**Pros:**
- Centralized code storage
- Backend and database already running
- Easy to sync updates

**Cons:**
- Need to copy files when updated
- Requires SSH access

### Option 2: Local Development
```
[Your Laptop]
  Mobile Code
  Flutter
  Emulator
  ↓
  Connects to AWS Backend
```

**Pros:**
- All code local
- Faster development
- No need to sync

**Cons:**
- Need to clone/download project first
- Keep backend URL pointing to AWS

---

## 🚀 RECOMMENDED SETUP

**For Quick Testing (Right Now):**
1. Copy mobile folder to laptop
2. Install Flutter
3. Run `flutter pub get && flutter run`

**For Long-term Development:**
1. Use Git repository
2. Clone to laptop
3. Develop locally
4. Push changes to Git
5. Pull on server if needed

---

## 📱 STEP-BY-STEP: COPY & RUN (Windows)

### 1. Install WinSCP
Download from: https://winscp.net/eng/download.php

### 2. Connect to Server
- Host: `3.24.31.8`
- Username: `ubuntu`
- Use your SSH key

### 3. Copy Mobile Folder
- Navigate to: `/home/ubuntu/Zelus/mobile`
- Drag and drop to: `C:\Projects\Zelus\mobile`

### 4. Install Flutter
- Download: https://docs.flutter.dev/get-started/install/windows
- Extract to: `C:\src\flutter`
- Add to PATH: `C:\src\flutter\bin`

### 5. Install Android Studio
- Download: https://developer.android.com/studio
- Create virtual device (Pixel 6)

### 6. Run App
```powershell
cd C:\Projects\Zelus\mobile
flutter pub get
flutter run
```

---

## 📱 STEP-BY-STEP: COPY & RUN (Mac)

### 1. Copy Mobile Folder
```bash
mkdir -p ~/Projects/Zelus
scp -r ubuntu@3.24.31.8:/home/ubuntu/Zelus/mobile ~/Projects/Zelus/
```

### 2. Install Flutter
```bash
cd ~/development
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.x.x-stable.zip
unzip flutter_macos_arm64_3.x.x-stable.zip
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

### 3. Install Xcode (for iOS)
- Install from App Store
- Run: `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`

### 4. Or Install Android Studio (for Android)
- Download from: https://developer.android.com/studio
- Create virtual device

### 5. Run App
```bash
cd ~/Projects/Zelus/mobile
flutter pub get
flutter run
```

---

## ⚠️ BEFORE RUNNING - CRITICAL STEP

**You MUST open port 8006 in AWS Security Group!**

1. AWS Console → EC2 → Security Groups
2. Edit Inbound Rules
3. Add Rule:
   - Type: Custom TCP
   - Port: 8006
   - Source: 0.0.0.0/0

4. Test from laptop:
```bash
curl http://3.24.31.8:8006/health
```

Expected: `{"status":"healthy","service":"zelux-api"}`

---

## 🎯 SUMMARY

**What You Have:**
- ✅ Backend running on AWS (port 8006)
- ✅ Mobile code on AWS server
- ✅ Mobile app configured to connect to AWS backend

**What You Need to Do:**
1. ⚠️ Open port 8006 in AWS Security Group
2. Copy mobile folder to your laptop (or clone project)
3. Install Flutter on laptop
4. Setup Android emulator or iOS simulator
5. Run: `flutter pub get && flutter run`
6. Login with: demo@zelux.com

**That's it!** 🎉

---

## 📞 QUESTIONS?

- Full setup guide: `/home/ubuntu/Zelus/SETUP_GUIDE.md`
- Deployment status: `/home/ubuntu/Zelus/DEPLOYMENT_STATUS.md`
- Quick start: `/home/ubuntu/Zelus/QUICK_START.txt`

---

**Updated:** October 11, 2025  
**Backend Port:** 8006 (Changed from 8000)  
**Server IP:** 3.24.31.8


