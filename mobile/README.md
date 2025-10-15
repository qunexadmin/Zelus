# Zelux Mobile App - Beauty Pro Network

Zelux mobile application built with Flutter - A beauty professional discovery platform with AI-powered features, social content, and external booking links to salons.

## ✨ Phase 1 MVP Features (October 2025)

### 🎨 Design System (October 15 Update)
- **Sophisticated Palette** - Charcoal (#1F2937) + Muted Gold (#B8956A)
- **Light Typography** - Inter font with ultra-light weights (w200-w400)
- **Minimalist Aesthetic** - Clean, luxurious, consistent across all screens
- **Haptic Feedback** - Enhanced touch interactions throughout
- **Entry Point** - Login page first, accepts email or phone (optional fields)
- **Navigation** - 4-tab bottom nav: Salons, Pros, Saved, Profile (Feed removed)

### Professional Profiles 👥
- **ProProfile Model** - Comprehensive professional profiles with services, portfolio, ratings, and experience
- **Book Now** - Opens external booking page (salon `bookingUrl`), no in-app flow
- **AI Review Highlights** - Smart 2-line summaries when ≥10 reviews available
- **Follow System** - Save and follow your favorite professionals

### Salon Pages 🏪
- **Staff Directory** - Browse all professionals at a salon
- **Booking Button** - Opens external `bookingUrl` in browser
- **Enhanced Details** - Services, amenities, hours, and contact information

### Discovery & Search 🔍
- **Explore Page** - Browse professionals and salons with filters
- **Advanced Filters** - City, service type, rating, and trending options
- **Lightweight Personalization** - Local ranking by searches, saves, and location
- **Responsive Design** - Tab-based navigation (Professionals/Salons)

### Content Upload & Management 📸
- **Photo Upload** - Share your work with automatic resizing
- **Video Support (≤60s)** - Cloudflare Stream integration (stub ready)
- **Rich Metadata** - Captions, tags, hashtags, and service types
- **Image Pipeline** - CDN-friendly processing

### AI-Powered Features 🤖
- **Auto-Tagging** - AI vision stub for detecting content tags (`/lib/ai/vision/auto_tagger.dart`)
- **Caption Generator** - Smart caption suggestions (`/lib/ai/caption/caption_suggester.dart`)
- **Review Summarizer** - Aggregate review insights (`/lib/ai/summary/ai_review_summarizer.dart`)
- **Trending Hashtags** - Discover popular tags across platforms (`/lib/feeds/trends/trend_source.dart`)

### Reviews & Ratings ⭐
- **Star Ratings** - 1-5 star system with text reviews
- **AI Summaries** - Two-line AI-generated highlights for popular professionals
- **User Attribution** - Photos and helpful vote counts

### Feeds & Recommendations 📱
- **Trending Now** - Hot content from across the platform
- **For You** - Personalized feed based on activity
- **Mixed Media** - Photos and short videos in unified feed
- **Local Scoring** - Tag overlap, location, and recency-based ranking

### External Trend Discovery 🌐
- **Instagram Integration** - Embedded posts via oEmbed (no re-hosting)
- **TikTok Support** - Trending beauty content with attribution
- **Compliance Footer** - Creator handle + platform logo on all external content
- **Deep Links** - "Open" button for viewing on source platform

### Collections & Saves 💾
- **Save Posts** - Bookmark inspiring content
- **Organize Collections** - Group saved items by theme
- **Quick Access** - `/collections` route for easy management

### Visual Search Hook (Phase 2) 🔮
- **Interface Only** - `VisualSearchService.search(keyword|image)` ready for integration
- **Attribution Model** - Returns items with sourceUrl and creator info
- **Future-Ready** - Plug in computer vision when ready

### User Engagement 💬
- **Saves & Collections** - Personal inspiration boards
- **Follow System** - Stay updated on favorite stylists/salons
- **Basic Following Feed** - Filter content from followed creators
- **Weekly AI Trend Radar** - Top trending tags (stub: `/lib/ai/insights/trend_radar.dart`)

## 🚀 Original Features

- 🔐 **Authentication** - Firebase authentication with email/password (mock mode enabled)
- 🏪 **Salon Discovery** - Browse and search salons and stylists
- 👤 **Stylist Profiles** - View portfolios, reviews, and specialties
  
  
> Note: Booking is handled via external links only in Phase 1. No in-app booking flow or payments.
- 🤖 **AI Preview** - AI-powered style previews (placeholder for future integration)
- 💳 **Payment Integration** - Stripe payment processing (placeholder)

## 🎛️ Feature Flags

All Phase 1 MVP features can be toggled via `/lib/core/feature_flags.dart`:

```dart
class FeatureFlags {
  static const bool externalTrends = true;        // Instagram/TikTok embeds
  static const bool aiSummaries = true;           // AI review summaries
  static const bool aiAutoTagging = true;         // Auto-detect tags
  static const bool aiCaptionSuggestions = true;  // Caption generator
  static const bool videoUpload = true;           // Video support
  static const bool follows = true;               // Follow system
  static const bool collections = true;           // Save collections
  static const bool visualSearchPhase2 = false;   // (Phase 2 only)
}
```

**To disable a feature:** Set its flag to `false`, then run `flutter run`.

## 🗂️ Mock Data Flow

By default, all services use mock data for development. Mock JSON files are located in `/assets/mock/`:

- `profiles.json` - Professional profiles
- `salons.json` - Salon listings
- `reviews.json` - Customer reviews
- `feeds.json` - Social feed items
- `oembed_samples.json` - External post embeds

**Services automatically fall back to mock data** if API calls fail or `FeatureFlags.mockData = true`.

### Where to Plug Real APIs

| Service | File | What to Replace |
|---------|------|-----------------|
| Professional Profiles | `/lib/data/services/profile_service.dart` | `_getMockProfiles()` |
| Reviews | `/lib/data/services/review_service.dart` | `_getMockReviews()` |
| AI Summaries | `/lib/ai/summary/ai_review_summarizer.dart` | Integrate GPT-4/Claude |
| oEmbed | `/lib/data/services/oembed_service.dart` | Add Instagram/TikTok tokens |
| Cloudflare Stream | `/lib/data/services/cloudflare_stream_service.dart` | Add accountId + apiToken |
| Auto-Tagging | `/lib/ai/vision/auto_tagger.dart` | Google Vision / AWS Rekognition |

## 🛠️ Tech Stack

- **Framework**: Flutter 3.0+
- **State Management**: Riverpod 2.4.9
- **Networking**: Dio 5.4.0
- **Navigation**: GoRouter 12.1.3 (initial route: `/login`)
- **UI**: Material Design 3 with custom design system
- **Typography**: Google Fonts (Inter) with light weights
- **Authentication**: Firebase Auth (disabled for web testing, optional login for dev)
- **Video Player**: video_player 2.8.1 + chewie 1.7.4
- **WebView**: webview_flutter 4.4.2 (for oEmbed)
- **Serialization**: freezed 2.4.5 + json_serializable 6.7.1
- **Local Storage**: Hive 2.2.3 + SharedPreferences 2.2.2

## 🎨 Design System Reference

All design tokens are centralized in `/lib/core/theme/app_theme.dart`:

### Color Palette
```dart
// Primary Colors
primaryColor: #1F2937   // Charcoal Black - primary actions
primaryDark: #111827    // Darker charcoal

// Accent Colors
accentColor: #B8956A    // Muted Gold - sophisticated accent
accentLight: #1AB8956A  // 10% opacity gold

// Surface Colors
surfaceColor: #F9FAFB   // Light gray backgrounds
borderLight: #E5E7EB    // Subtle borders
dividerColor: #F3F4F6   // Dividers

// Text Colors
textPrimary: #000000    // Black
textSecondary: #6B7280  // Gray 500
textTertiary: #9CA3AF   // Gray 400

// Semantic Colors
errorColor: #DC2626     // Red 600
successColor: #059669   // Green 600
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

### Border Radius & Spacing
- Cards: `12px` radius
- Buttons: `12px` radius
- Chips: `20px` radius
- Standard padding: `24px` horizontal
- Card spacing: `16px` between elements

### Design Principles
1. **Minimalism** - Clean layouts, generous whitespace
2. **Light Typography** - Prefer w200-w400 weights for elegance
3. **Subtle Accents** - Use muted gold sparingly for emphasis
4. **Consistency** - Apply theme colors throughout
5. **Haptic Feedback** - Add to all interactive elements

## Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- iOS Simulator / Android Emulator / Physical Device
- Firebase project (for authentication)

## 🚀 Getting Started

### 1. Install Dependencies

```bash
cd mobile
flutter pub get

# Generate freezed models (required for Phase 1 models)
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Configure API Endpoint

Update the API base URL in `lib/core/api/api_client.dart`:

```dart
const String kApiBaseUrl = 'http://YOUR_BACKEND_URL:8000/api/v1';
```

For local development:
- iOS Simulator: `http://localhost:8000/api/v1`
- Android Emulator: `http://10.0.2.2:8000/api/v1`
- Physical Device: `http://YOUR_LOCAL_IP:8000/api/v1`

### 3. Firebase Setup (Optional)

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Add iOS and/or Android app to your Firebase project
3. Download and place configuration files:
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`
   - Android: `google-services.json` → `android/app/`
4. Enable Email/Password authentication in Firebase Console

### 4. Run the App

```bash
# Check for connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run in release mode
flutter run --release
```

## 📂 Project Structure

```
lib/
├── main.dart                # App entry point
├── core/
│   ├── api/                # API client configuration
│   ├── feature_flags.dart  # [NEW] Feature toggles
│   ├── router/             # App navigation (starts at /login)
│   ├── theme/              # [UPDATED] Design system (charcoal/gold palette)
│   │   └── app_theme.dart  # Charcoal #1F2937, Muted Gold #B8956A, Inter font
│   └── widgets/            # [NEW] Shared UI components
│       ├── pro_profile_card.dart
│       ├── booking_request_sheet.dart
│       ├── rating_bar.dart
│       ├── tag_chips.dart
│       ├── hashtag_chips.dart
│       ├── embedded_post_widget.dart
│       ├── media_tile.dart
│       ├── save_button.dart
│       └── follow_button.dart
├── data/                   # [NEW] Data layer
│   ├── models/             # Freezed data models
│   │   ├── pro_profile.dart
│   │   ├── salon.dart
│   │   ├── review.dart
│   │   ├── feed_item.dart
│   │   ├── booking_request.dart
│   │   ├── oembed_data.dart
│   │   ├── stream_asset.dart
│   │   └── collection.dart
│   └── services/           # Business logic services
│       ├── profile_service.dart
│       ├── salon_service.dart
│       ├── review_service.dart
│       ├── feed_service.dart
│       ├── booking_service.dart
│       ├── trend_service.dart
│       ├── oembed_service.dart
│       ├── cloudflare_stream_service.dart
│       └── personalization_store.dart
├── ai/                     # [NEW] AI stubs
│   ├── vision/auto_tagger.dart
│   ├── caption/caption_suggester.dart
│   ├── summary/ai_review_summarizer.dart
│   └── insights/trend_radar.dart
└── features/
    ├── auth/               # [UPDATED] Login (email/phone, optional fields)
    ├── home/               # [UPDATED] 4-tab bottom nav (Feed removed)
    │   └── widgets/
    │       ├── discover_tab.dart    # [REDESIGNED] Dynamic greeting, AI insights
    │       └── profile_tab.dart     # [REDESIGNED] Stats, removed Quick Access
    ├── salons/             # [UPDATED] Salon discovery & enhanced details
    ├── stylists/           # [UPDATED] Stylist profiles with new design
    ├── bookings/           # Booking flow
    ├── ai_preview/         # AI style preview
    ├── feed/               # Social feed & reels (removed from nav)
    ├── explore/            # [UPDATED] Discovery with elegant filters
    ├── pros/               # [NEW] Professional profiles
    ├── upload/             # [NEW] Content upload
    ├── collections/        # [UPDATED] Refined grid with themed cards
    └── visual_search/      # [NEW] Phase 2 interface stub

assets/mock/                # [NEW] Mock data JSON files
├── profiles.json
├── salons.json
├── reviews.json
├── feeds.json
└── oembed_samples.json
```

## 📱 Key Screens & Routes

### Core Navigation (Updated October 15)
- **`/login`** - **Entry point** - Email or phone login (optional fields for dev)
- **`/`** - Home screen with 4 tabs: Salons (Discover), Pros (Explore), Saved (Collections), Profile
- **`/explore`** - Discovery page with advanced filters (city, service, rating)
- **`/upload`** - Content upload with AI assistance (FAB button)
- **`/collections`** - Saved collections manager

### Professionals & Salons
- **`/pros/:id`** - [NEW] Full professional profile page
- **`/salon/:id`** - Salon details with staff directory
- **`/stylist/:id`** - Stylist profile (existing)
- **`/booking`** - Booking flow with service/date/time selection

### Social & Content
- **`/reels`** - Vertical swipe video feed
- **`/feed`** - Social feed (For You / Trending / Following)
- **Embedded Posts** - Instagram/TikTok via oEmbed (in feed)

### AI Features
- **`/ai-preview`** - AI style preview (placeholder)
- **Auto-tagging** - Runs during upload
- **Caption suggestions** - Shows in upload screen
- **Review summaries** - Visible on pro profiles with ≥10 reviews

### Other
- **`/stylist-onboard`** - Stylist registration form

## Development Notes

### Mock Data
The app currently uses mock data for development. TODO comments indicate where API integration should be added:

```dart
// TODO: Fetch from API
// final salons = ref.watch(salonsProvider);
```

### Firebase Integration
Firebase authentication is partially integrated. Uncomment and configure:

```dart
// In main.dart
await Firebase.initializeApp();

// In login_screen.dart
final authService = ref.read(authServiceProvider);
await authService.signInWithEmail(email, password);
```

### State Management
The app uses Riverpod for state management. Add providers in respective feature folders:

```dart
final salonsProvider = FutureProvider<List<Salon>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/salons');
  return (response.data as List).map((e) => Salon.fromJson(e)).toList();
});
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

## 🔌 Integration & API Hookup

### Where to Plug Real APIs

All services currently use mock data. Replace these stubs:

| Service | File | What to Do |
|---------|------|------------|
| **Professional Profiles** | `lib/data/services/profile_service.dart` | Replace `_getMockProfiles()` with real API |
| **Reviews** | `lib/data/services/review_service.dart` | Replace `_getMockReviews()` with real API |
| **AI Summaries** | `lib/ai/summary/ai_review_summarizer.dart` | Integrate GPT-4/Claude API |
| **oEmbed** | `lib/data/services/oembed_service.dart` | Add Instagram/TikTok API tokens |
| **Cloudflare Stream** | `lib/data/services/cloudflare_stream_service.dart` | Add `accountId` + `apiToken` |
| **Auto-Tagging** | `lib/ai/vision/auto_tagger.dart` | Integrate Google Vision / AWS Rekognition |

### Code Generation Required

After pulling changes, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates `.freezed.dart` and `.g.dart` files for all models.

## ⚡ Quick Commands

```bash
# Install dependencies
flutter pub get

# Generate code (freezed models)
flutter pub run build_runner build --delete-conflicting-outputs

# Run app (debug mode with hot reload)
flutter run -d chrome

# Run with specific feature flags
# Edit lib/core/feature_flags.dart, then:
flutter run

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

## 🧪 Testing Phase 1 MVP

### Test Checklist

1. **Professional Profiles**
   ```
   Navigate: /explore → Tap any professional
   ✓ Profile loads with portfolio grid
   ✓ "Book Now" opens BookingRequestSheet
   ✓ AI review summary appears (if ≥10 reviews)
   ✓ Follow button works
   ```

2. **Explore Filters**
   ```
   Navigate: /explore
   ✓ Apply city filter → results update
   ✓ Apply service filter → results update
   ✓ Apply rating filter → results update
   ✓ "Clear All" resets filters
   ```

3. **Upload Flow**
   ```
   Navigate: /upload → Select photo
   ✓ Auto-tags appear after selection
   ✓ Caption suggestions load
   ✓ Can tap suggestion to use
   ✓ "Post" button uploads (mock)
   ```

4. **Collections**
   ```
   Navigate: /collections
   ✓ Can create new collection
   ✓ SaveButton on posts works
   ✓ Collections display count
   ```

5. **oEmbed (External Content)**
   ```
   View any embedded Instagram/TikTok post
   ✓ Content loads in WebView
   ✓ Attribution footer shows
   ✓ "Open" link launches external app/browser
   ```

## 🚀 Future Enhancements (Phase 2+)

- [ ] Visual search (computer vision-based)
- [ ] Complete Firebase authentication integration
- [ ] Real-time chat with stylists
- [ ] Push notifications
- [ ] Payment processing with Stripe
- [ ] Integrate AI styling service
- [ ] Live video streaming
- [ ] Advanced analytics dashboard
- [ ] Dark mode support

## Contributing

1. Follow Flutter style guide
2. Run `flutter analyze` before committing
3. Format code with `flutter format .`
4. Update tests for new features

## License

Copyright © 2025 Zelux. All rights reserved.

