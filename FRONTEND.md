# 📱 Frontend Documentation

**Flutter Mobile App for Zelux Platform**

---

## 📊 Current Status

**Status:** ✅ Phase 1 MVP Complete  
**Version:** v1.1.0 (Beauty Pro Network)  
**Platform:** Flutter (Mobile + Web)  
**API Endpoint:** http://3.24.31.8:8006/api/v1  
**Test Mode:** Chrome (Web)  
**Last Updated:** October 14, 2025

---

## 🏗️ Tech Stack

- **Framework:** Flutter 3.x
- **Language:** Dart 3.x
- **State Management:** Riverpod 2.4.9
- **Navigation:** GoRouter 12.1.3
- **HTTP Client:** Dio 5.4.0 + Retrofit 4.0.3
- **UI Library:** Material Design 3
- **Fonts:** Google Fonts 6.1.0

---

## 📁 Project Structure

```
mobile/
├── lib/
│   ├── features/              # Feature modules
│   │   ├── auth/             # Authentication
│   │   │   ├── data/         # API & models
│   │   │   ├── domain/       # Business logic
│   │   │   └── presentation/ # UI screens
│   │   ├── home/             # Home/Discover
│   │   ├── salons/           # Salon features
│   │   ├── stylists/         # Stylist features
│   │   ├── bookings/         # Booking features
│   │   └── ai/               # AI preview
│   ├── core/                  # Shared utilities
│   │   ├── api/              # API client
│   │   ├── router/           # Navigation
│   │   ├── theme/            # App theme
│   │   └── widgets/          # Shared widgets
│   └── main.dart             # App entry point
├── assets/                    # Images & icons
├── pubspec.yaml              # Flutter dependencies
└── README.md                 # Mobile-specific docs
```

---

## ⚙️ Configuration

### API Endpoint

**File:** `lib/core/api/api_client.dart`

```dart
const String kApiBaseUrl = 'http://3.24.31.8:8006/api/v1';
```

**Change for different environments:**
- **Development (Server):** `http://localhost:8006/api/v1`
- **Development (Laptop):** `http://3.24.31.8:8006/api/v1`
- **Android Emulator:** `http://10.0.2.2:8006/api/v1`
- **iOS Simulator:** `http://localhost:8006/api/v1`
- **Production:** `https://api.zelux.com/api/v1`

---

## 🚀 Setup & Installation

### 1. Prerequisites

**Install Flutter:**
- **Windows:** https://docs.flutter.dev/get-started/install/windows
- **Mac:** https://docs.flutter.dev/get-started/install/macos
- **Linux:** https://docs.flutter.dev/get-started/install/linux

**Verify Installation:**
```bash
flutter --version
flutter doctor
```

### 2. Clone Repository
```bash
git clone https://github.com/qunexadmin/Zelus.git
cd Zelus/mobile
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Update API Endpoint (if needed)
Edit `lib/core/api/api_client.dart`:
```dart
const String kApiBaseUrl = 'http://YOUR_IP:8006/api/v1';
```

---

## 🎮 Running the App

### Option 1: Chrome (Web) - Fastest for Testing
```bash
cd mobile
flutter run -d chrome
```

### What to test (Phase 1 MVP)
- **5-Tab Navigation:** Salons | Pros | Feed | Saved | Profile
- **Pros Tab:** Browse professionals, apply filters (city/service/rating)
- **Pro Profiles:** Tap any pro → Full profile → "Book Now" button
- **Upload:** Tap FAB → Select photo → See AI tags & caption suggestions
- **Collections:** Saved tab → Create collections
- **Trending:** Profile → Tap "Trending" card → External posts
- **Feed tabs:** For You / Trending / Following
- **Reels:** Tap play icon in Feed app bar (vertical swipe)
- **Quick Access:** Profile tab → 4 feature cards (Trending/Upload/Reels/AI)

### Option 2: Android Emulator
```bash
# Start Android emulator first (from Android Studio)
# Then run:
flutter run
```

### Option 3: iOS Simulator (Mac Only)
```bash
# Open simulator
open -a Simulator

# Run app
flutter run
```

### Option 4: Physical Device
```bash
# Connect device via USB
# Enable USB debugging (Android) or trust computer (iOS)
flutter devices
flutter run -d <device-id>
```

---

## 🔐 Login Credentials

**Mock Authentication Enabled**

Use any of these credentials:
- **Email:** `demo@zelux.com` / **Password:** `anything`
- **Email:** `customer1@example.com` / **Password:** `anything`
- **Email:** `customer2@example.com` / **Password:** `anything`

**Or literally ANY email/password combination!**

---

## 🎨 App Screens

### 1. Authentication
- **Login Screen** - Email/password authentication
- Mock auth (Firebase ready for production)

### 2. Home / Discover
- **Discover Tab** - Browse featured salons
- Category filters (Haircut, Color, Styling, Spa, Nails)
- Search functionality
- Salon cards with ratings & images

### 3. Salon Details
- Salon information & location
- List of stylists
- Services offered
- Reviews & ratings

### 4. Stylist Profile
- Stylist bio & specialties
- Portfolio images
- Available services
- Reviews & ratings
- "Book Appointment" button

### 5. Booking Flow
- **Step 1:** Select service
- **Step 2:** Choose date (calendar)
- **Step 3:** Select time slot
- **Step 4:** Confirm & book

### 6. My Bookings
- List of user's bookings
- Filter by status (Upcoming, Past, Cancelled)
- Booking details
- Cancel option

### 7. AI Preview (Placeholder)
- Upload photo
- Try different hairstyles
- Mock AI results (for testing)

---

## 🛠️ Development

### Hot Reload
```bash
# While app is running, press:
r    # Hot reload
R    # Hot restart
q    # Quit
```

### Code Generation
```bash
# Generate code (if using build_runner)
flutter pub run build_runner build

# Watch for changes
flutter pub run build_runner watch
```

### Format Code
```bash
flutter format lib/
```

### Analyze Code
```bash
flutter analyze
```

### Run Tests
```bash
flutter test
```

---

## 📦 Dependencies

### Core
```yaml
flutter_riverpod: ^2.4.9      # State management
go_router: ^12.1.3            # Navigation
dio: ^5.4.0                   # HTTP client
retrofit: ^4.0.3              # Type-safe API
```

### UI
```yaml
google_fonts: ^6.1.0          # Fonts
cached_network_image: ^3.3.0  # Image caching
shimmer: ^3.0.0               # Loading effects
flutter_svg: ^2.0.9           # SVG support
```

### Features
```yaml
image_picker: ^1.0.5          # Camera/gallery
table_calendar: ^3.0.9        # Date picker
shared_preferences: ^2.2.2    # Local storage
intl: ^0.18.1                 # Internationalization
```

### Firebase (Currently Disabled for Web Testing)
```yaml
# firebase_core: ^2.24.2       # Commented out
# firebase_auth: ^4.15.3       # Commented out
```

---

## 🌐 Platform-Specific Setup

### Android

**Requirements:**
- Android Studio
- Android SDK (API 33+)
- Android Virtual Device (AVD)

**Setup:**
1. Open Android Studio
2. Tools → Device Manager
3. Create Device → Pixel 6
4. Download system image (API 33)
5. Start emulator

**Config:** `mobile/android/app/build.gradle`

### iOS (Mac Only)

**Requirements:**
- Xcode (from App Store)
- CocoaPods

**Setup:**
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
sudo gem install cocoapods
```

**Config:** `mobile/ios/Runner.xcworkspace`

### Web (Chrome)

**No additional setup needed!**

Just run:
```bash
flutter run -d chrome
```

**Note:** Firebase disabled for web testing (can be re-enabled)

---

## 🐛 Troubleshooting

### Flutter Not Found
```bash
# Check PATH
echo $PATH  # Mac/Linux
$env:Path   # Windows

# Add Flutter to PATH
export PATH="$PATH:/path/to/flutter/bin"  # Mac/Linux
```

### No Devices Found
```bash
# Check available devices
flutter devices

# Android: Start emulator from Android Studio
# iOS: Open Simulator app
# Web: Should always be available
```

### Can't Connect to API
```bash
# Check API endpoint in lib/core/api/api_client.dart
# Test backend: curl http://3.24.31.8:8006/health
# Verify AWS port 8006 is open
```

### Build Errors
```bash
flutter clean
flutter pub get
flutter run
```

### Firebase Web Errors
**Solution:** Firebase is disabled for web testing. It's normal!

To re-enable:
1. Uncomment Firebase in `pubspec.yaml`
2. Uncomment Firebase import in `main.dart`
3. Run `flutter pub get`

---

## 🎯 Features

### ✅ Phase 1 MVP Implemented (October 14, 2025)
- **Professional Profiles** - Full profiles with portfolio, reviews, ratings
- **Advanced Discovery** - Filters (city, service, rating), Pros/Salons tabs
- **Content Upload** - Photo/video upload with AI auto-tagging & captions
- **Collections** - Save posts, organize collections
- **Trending Screen** - External Instagram/TikTok posts via oEmbed
- **AI Features (Stubs)** - Auto-tagging, caption suggestions, review summaries
- **Booking Requests** - "Book Now" sheet (no payment)
- **Follow System** - Follow buttons ready
- **5-Tab Navigation** - Salons | Pros | Feed | Saved | Profile
- **Feature Flags** - Toggle 19+ features
- **Mock Data System** - 5 JSON files, automatic fallback
- **10+ UI Components** - Reusable widgets

### ✅ Social Platform (October 12, 2025)
- Social feed (For You/Trending/Following)
- Reels (full-screen vertical)
- Login-gated like/comment
- Stylist onboarding (form)
- Tagging UI (MVP)
- Modern Material Design 3 theme

### 🚧 Placeholders (Ready for Integration)
- Firebase authentication (disabled for web testing)
- Stripe payment processing (Phase 2)
- Real AI services (GPT-4, Vision API, etc.)
- Cloudflare Stream (video upload stub ready)
- Visual search (Phase 2 interface created)
- Push notifications
- In-app chat
- Real backend API (currently mock data)

---

## 🔐 Security

### Current Setup
- ✅ Mock authentication
- ✅ HTTP client (Dio)
- ✅ API token ready (not used yet)
- ⚠️ HTTP only (need HTTPS for production)

### Production Todos
- [ ] Enable Firebase authentication
- [ ] Add API token authentication
- [ ] Configure HTTPS
- [ ] Add biometric authentication
- [ ] Implement secure storage (flutter_secure_storage)

---

## 📊 State Management

**Using Riverpod:**

```dart
// Provider example
final salonsProvider = FutureProvider<List<Salon>>((ref) async {
  final api = ref.read(dioProvider);
  return api.getSalons();
});

// Consumer example
Consumer(
  builder: (context, ref, child) {
    final salons = ref.watch(salonsProvider);
    return salons.when(
      data: (data) => SalonList(salons: data),
      loading: () => LoadingWidget(),
      error: (err, stack) => ErrorWidget(err),
    );
  },
)
```

---

## 🎨 Theming

**Theme:** `lib/core/theme/app_theme.dart`

### Colors
- **Primary:** `#8B7EFF` (Purple)
- **Secondary:** `#FF6B9D` (Pink)
- **Surface:** `#FFFFFF`
- **Background:** `#F8F9FA`

### Typography
- **Font:** Inter (Google Fonts)
- **Headings:** 600 weight
- **Body:** 400 weight

---

## 📱 Testing Flow

### Complete User Journey
1. **Open app** → Login screen
2. **Login** with `demo@zelux.com`
3. **Browse** salons in Discover tab
4. **Tap** on "Elite Hair Studio"
5. **View** salon details
6. **Tap** on "Jane Smith" (stylist)
7. **View** stylist profile
8. **Tap** "Book Appointment"
9. **Select** service (e.g., "Women's Haircut")
10. **Choose** date from calendar
11. **Select** time slot
12. **Confirm** booking
13. **View** booking in "Bookings" tab

---

## 🔄 Version Control

### Branch Strategy
- `main` - Production-ready code
- `dev` - Development branch
- `feature/*` - Feature branches

### Before Committing
```bash
flutter analyze
flutter format lib/
flutter test
```

---

## 📦 Building for Production

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS
```bash
flutter build ios --release
# Use Xcode to submit to App Store
```

### Web
```bash
flutter build web --release
# Output: build/web/
```

---

## 📞 Support

**Repository:** https://github.com/qunexadmin/Zelus  
**Issues:** GitHub Issues  
**Flutter Docs:** https://docs.flutter.dev

---

## 📝 Progress Tracking

### October 14, 2025 - Phase 1 MVP Complete! 🎉
- ✅ **70+ new files created**
  - 8 data models (freezed + json_serializable)
  - 9 service layer classes
  - 4 AI stub services
  - 10+ reusable UI widgets
  - 5+ new feature screens
  - 5 mock JSON data files
- ✅ **Navigation enhanced**
  - 5-tab bottom navigation
  - Floating action button for upload
  - Quick access cards in profile
  - All routes documented
- ✅ **Feature flags system** - 19+ toggleable features
- ✅ **Comprehensive documentation**
  - README.md updated
  - MIGRATION_NOTES.md created
  - FEATURE_ACCESS_GUIDE.md created
- ✅ **All Phase 1 requirements met**

### October 12, 2025 - Social Platform Evolution
- ✅ Mobile app configured
- ✅ API endpoint set to AWS backend
- ✅ Firebase disabled for web testing
- ✅ Chrome testing enabled
- ✅ Feed tabs & reels implemented
- ✅ Social features integrated

### Next Steps (Phase 2)
- [ ] Integrate real AI services (GPT-4, Vision API)
- [ ] Connect Cloudflare Stream (video upload)
- [ ] Re-enable Firebase authentication
- [ ] Replace mock data with backend API
- [ ] Add Instagram/TikTok oEmbed tokens
- [ ] Implement Stripe payments
- [ ] Visual search implementation
- [ ] Build and deploy to stores

---

**Last Updated:** October 12, 2025


