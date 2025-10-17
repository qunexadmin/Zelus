# Zelux Mobile App - Beauty Pro Network

Zelux mobile application built with Flutter - A beauty professional discovery platform with social content and booking features.

**Last Updated:** October 17, 2025 - Retail & Product Discovery! 🛍️

## ✨ Current Features

### 🎨 Design System
- **Sophisticated Palette** - Charcoal (#1F2937) + Muted Gold (#B8956A)
- **Light Typography** - Inter font with ultra-light weights (w200-w400)
- **Minimalist Aesthetic** - Clean, luxurious, consistent across all screens
- **Haptic Feedback** - Enhanced touch interactions throughout
- **Entry Point** - Login page first, accepts email or phone (optional fields)
- **Navigation** - 4-tab bottom nav: Home, **Explore**, Saved, Profile (clean & intuitive)

### Professional Profiles 👥
- **ProProfile Model** - Comprehensive professional profiles with services, portfolio, ratings
- **Book Now** - Contact and booking integration
- **AI Review Highlights** - Smart 2-line summaries when ≥10 reviews available
- **Follow System** - Save and follow your favorite professionals

### Salon Pages 🏪
- **Staff Directory** - Browse all professionals at a salon
- **Enhanced Details** - Services, amenities, hours, and contact information
- **Location & Map** - Find salons near you

### Discovery & Search 🔍
- **Explore Page** - Unified discovery hub with 3 tabs (Professionals | Salons | Retail)
- **Advanced Filters** - City, service type, rating, and trending options
- **Lightweight Personalization** - Local ranking by searches, saves, and location
- **Seamless Switching** - Easy navigation between pros, salons, and products
- **Better UX** - All discovery features in one logical place

### AI-Powered Features 🤖
- **Review Summarizer** - Aggregate review insights (`/lib/ai/summary/ai_review_summarizer.dart`)
- **Trending Insights** - Discover popular trends (`/lib/ai/insights/trend_radar.dart`)

### Reviews & Ratings ⭐
- **Star Ratings** - 1-5 star system with text reviews
- **AI Summaries** - Two-line AI-generated highlights for popular professionals
- **User Attribution** - Photos and helpful vote counts

### Collections & Saves 💾
- **Save Posts** - Bookmark inspiring content
- **Organize Collections** - Group saved items by theme
- **Quick Access** - `/collections` route for easy management

### Trending Content 🌐
- **Trending Feed** - Hot content from across the platform
- **Embedded Posts** - Display external content with attribution
- **Deep Links** - View content on source platforms

### Retail & Product Discovery 🛍️
- **Integrated in Explore** - 3rd tab alongside Professionals and Salons
- **AI Product Search** - Discover beauty products via shared search bar
- **Smart Sections:**
  - **Price Drop Alerts** - Green banners for products on sale
  - **AI Recommendations** - Based on your visits & preferences
  - **Trending Products** - Popular items this week
  - **Your Watchlist** - Track prices on saved products
  - **Hot Deals** - Limited time offers with discount badges
- **Product Cards** - Brand, price, ratings, discount badges, save/bookmark
- **Mock Data** - ~40 realistic products (OLAPLEX, K18, DYSON, GHD, MOROCCAN OIL, etc.)
- **Future Ready** - Prepared for SerpAPI/Google Shopping API integration

## 🛠️ Tech Stack

- **Framework**: Flutter 3.0+
- **State Management**: Riverpod 2.4.9
- **Networking**: Dio 5.4.0
- **Navigation**: GoRouter 12.1.3 (initial route: `/login`)
- **UI**: Material Design 3 with custom design system
- **Typography**: Google Fonts (Inter) with light weights
- **Authentication**: Firebase Auth (optional for development)
- **WebView**: webview_flutter 4.4.2
- **Serialization**: freezed 2.4.5 + json_serializable 6.7.1
- **Local Storage**: Hive 2.2.3 + SharedPreferences 2.2.2

## 🎨 Design System Reference

All design tokens are centralized in `/lib/core/theme/app_theme.dart`:

### Color Palette
```dart
// Primary Colors
primaryColor: #1F2937   // Charcoal Black
primaryDark: #111827    // Darker charcoal

// Accent Colors
accentColor: #B8956A    // Muted Gold
accentLight: #1AB8956A  // 10% opacity gold

// Surface Colors
surfaceColor: #F9FAFB   // Light gray backgrounds
borderLight: #E5E7EB    // Subtle borders
dividerColor: #F3F4F6   // Dividers

// Text Colors
textPrimary: #000000    // Black
textSecondary: #6B7280  // Gray 500
textTertiary: #9CA3AF   // Gray 400
```

### Typography (Inter Font)
```dart
displayLarge:   64px, w200, letterSpacing: 14    // Ultra-light hero text
headlineLarge:  34px, w300, letterSpacing: -1.2  // Section headers
headlineMedium: 28px, w300, letterSpacing: -0.5  // Card titles
headlineSmall:  24px, w400                       // Subsections
bodyLarge:      16px, w400                       // Body text
bodyMedium:     15px, w300                       // Light body
bodySmall:      13px, w400                       // Captions
```

## Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- iOS Simulator / Android Emulator / Physical Device

## 🚀 Getting Started

### 1. Install Dependencies

```bash
cd mobile
flutter pub get

# Generate freezed models (if needed)
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Configure API Endpoint

Update the API base URL in `lib/core/api/api_client.dart`:

```dart
const String kApiBaseUrl = 'http://YOUR_BACKEND_URL:8006/api/v1';
```

For local development:
- iOS Simulator: `http://localhost:8006/api/v1`
- Android Emulator: `http://10.0.2.2:8006/api/v1`
- Physical Device: `http://YOUR_LOCAL_IP:8006/api/v1`

### 3. Run the App

```bash
# Check for connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run in Chrome (for web testing)
flutter run -d chrome

# Run in release mode
flutter run --release
```

## 📂 Project Structure (Simplified!)

```
lib/
├── main.dart                # App entry point
├── core/                    # Core utilities (11 files)
│   ├── api/
│   │   └── api_client.dart         # API configuration
│   ├── feature_flags.dart          # Feature toggles
│   ├── models/
│   │   └── user.dart               # User model
│   ├── router/
│   │   └── app_router.dart         # Navigation config
│   ├── theme/
│   │   └── app_theme.dart          # Design system
│   └── widgets/                    # Shared widgets (6 files)
│       ├── embedded_post_widget.dart
│       ├── follow_button.dart
│       ├── media_tile.dart
│       ├── pro_profile_card.dart
│       ├── rating_bar.dart
│       └── tag_chips.dart
│
├── data/                    # Data layer (12 files)
│   ├── models/             # Data models (6 files)
│   │   ├── collection.dart
│   │   ├── feed_item.dart
│   │   ├── oembed_data.dart
│   │   ├── pro_profile.dart
│   │   ├── review.dart
│   │   └── salon.dart
│   └── services/           # Business logic (6 files)
│       ├── feed_service.dart
│       ├── oembed_service.dart
│       ├── personalization_store.dart
│       ├── profile_service.dart
│       ├── review_service.dart
│       └── salon_service.dart
│
├── ai/                     # AI features (2 files)
│   ├── summary/ai_review_summarizer.dart
│   └── insights/trend_radar.dart
│
└── features/
    └── screens/            # ALL SCREENS IN ONE FOLDER! (11 files)
        ├── login_screen.dart           # Login/auth
        ├── home_screen.dart            # 4-tab navigation
        ├── discover_tab.dart           # Home feed
        ├── profile_tab.dart            # User profile
        ├── explore_screen.dart         # Pros/Salons/Retail (3 tabs)
        ├── pro_profile_screen.dart     # Professional profiles
        ├── salon_detail_screen.dart    # Salon pages
        ├── collections_screen.dart     # Saved collections
        ├── trending_screen.dart        # Trending content
        ├── ai_preview_screen.dart      # AI try-on preview
        └── stylist_onboard_screen.dart # Onboarding flow
```

**Total: 11 screens, 12 data files, 11 core files - Clean and simple!**

## 📱 Key Screens & Routes

### Core Navigation
- **`/login`** - **Entry point** - Email or phone login
- **`/`** - Home screen with 4 tabs: Home, **Explore**, Saved, Profile
- **`/explore`** - Unified discovery with 3 tabs: Professionals | Salons | Retail
- **`/collections`** - Saved collections manager
- **`/trending`** - Trending content feed

### Professionals & Salons
- **`/pros/:id`** - Full professional profile page
- **`/salon/:id`** - Salon details with staff directory
- **`/stylist/:id`** - Stylist profile (uses ProProfileScreen)

### AI Features
- **`/ai-preview`** - AI style preview
- **`/stylist-onboard`** - Stylist registration form

## Development Notes

### State Management
The app uses Riverpod for state management. Add providers in respective service files:

```dart
final profilesProvider = FutureProvider<List<ProProfile>>((ref) async {
  final service = ref.read(profileServiceProvider);
  return service.getProfiles();
});
```

### Feature Flags
Toggle features via `lib/core/feature_flags.dart`:

```dart
class FeatureFlags {
  static const bool aiSummaries = true;
  static const bool collections = true;
  static const bool follows = true;
  // ... more flags
}
```

## Building for Production

### iOS
```bash
flutter build ios --release
```

### Android
```bash
flutter build apk --release      # APK
flutter build appbundle          # App Bundle (for Play Store)
```

### Web
```bash
flutter build web --release
```

## Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## Code Generation

If using code generation (for Riverpod, JSON serialization, etc.):

```bash
# Watch for changes
flutter pub run build_runner watch --delete-conflicting-outputs

# One-time build
flutter pub run build_runner build --delete-conflicting-outputs
```

## Troubleshooting

### iOS Build Issues
```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
```

### Android Build Issues
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
```

### Network Connection Issues
- Ensure backend is running
- Check API URL configuration
- Verify device can reach backend (use ping or browser)
- Check firewall settings

## ⚡ Quick Commands

```bash
# Install dependencies
flutter pub get

# Generate code (freezed models)
flutter pub run build_runner build --delete-conflicting-outputs

# Run app (debug mode with hot reload)
flutter run -d chrome

# Build for production
flutter build apk --release           # Android
flutter build ios --release           # iOS
flutter build web --release           # Web

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format lib/
```

## 🚀 Recent Updates

### October 17, 2025 - Retail & Product Discovery (Refined UX)
- ✅ **Retail Integrated into Explore** - Better information architecture
- ✅ **4-Tab Navigation** - Home | Explore | Saved | Profile (cleaner!)
- ✅ **Explore Enhanced** - 3 tabs: Professionals | Salons | **Retail**
  - Unified discovery experience
  - Seamless context switching
  - All exploration in one place
- ✅ **Retail Features:**
  - Price drop alerts with notification banners
  - Watchlist section for tracked products
  - Product cards with discount badges, ratings, save/bookmark
  - AI recommendations based on visits
  - Trending products & hot deals
- ✅ **Mock Data** - ~40 realistic beauty products ($8-$549 range)
- ✅ **Design Consistency** - Same charcoal/gold theme, light typography
- ✅ **Removed** - Category filters (can add back if needed)
- ✅ **Future Ready** - Prepared for SerpAPI/Google Shopping API integration

### October 16, 2025 - Codebase Cleanup
- ✅ **Simplified folder structure**
  - Consolidated 9 feature folders → 1 flat screens folder
  - Removed unused features (feed, upload, visual_search)
  - Cleaned up data folder (removed 3 unused files)
  - Cleaned up core widgets (removed 3 unused widgets)
- ✅ **Updated imports**
  - All import paths simplified
  - No linter errors
- ✅ **Result**: 67% fewer folders, easier navigation, cleaner codebase

### October 15, 2025 - Design System Overhaul
- Complete UI redesign with sophisticated design system
- Charcoal & muted gold color palette
- Light typography (Inter font, w200-w400 weights)
- Login page as entry point
- 4-tab bottom navigation
- Enhanced haptic feedback throughout

## Contributing

1. Follow Flutter style guide
2. Run `flutter analyze` before committing
3. Format code with `flutter format .`
4. Update tests for new features
5. Keep the folder structure simple!

## License

Copyright © 2025 Zelux. All rights reserved.
