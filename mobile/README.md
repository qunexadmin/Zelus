# Zelux Mobile App

Zelux mobile application built with Flutter - A stylist-first platform connecting customers with professional stylists.

## Features

- 🔐 **Authentication** - Firebase authentication with email/password
- 🏪 **Salon Discovery** - Browse and search salons and stylists
- 👤 **Stylist Profiles** - View portfolios, reviews, and specialties
- 📅 **Booking System** - Complete booking flow with date/time selection
- 🤖 **AI Preview** - AI-powered style previews (placeholder for future integration)
- 💳 **Payment Integration** - Stripe payment processing (placeholder)

## Tech Stack

- **Framework**: Flutter 3.0+
- **State Management**: Riverpod
- **Networking**: Dio
- **Navigation**: GoRouter
- **UI**: Material Design 3
- **Authentication**: Firebase Auth

## Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- iOS Simulator / Android Emulator / Physical Device
- Firebase project (for authentication)

## Getting Started

### 1. Install Dependencies

```bash
cd mobile
flutter pub get
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

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── core/
│   ├── api/                 # API client configuration
│   ├── models/              # Shared data models
│   ├── router/              # App navigation
│   └── theme/               # App theme & styling
└── features/
    ├── auth/                # Authentication screens
    ├── home/                # Home screen with tabs
    ├── salons/              # Salon discovery & details
    ├── stylists/            # Stylist profiles
    ├── bookings/            # Booking flow
    └── ai_preview/          # AI style preview
```

## Key Screens

### Authentication
- **LoginScreen**: Email/password login with social auth options

### Home
- **DiscoverTab**: Browse salons, search, categories
- **BookingsTab**: View upcoming and past appointments
- **ProfileTab**: User profile and settings

### Booking Flow
- **SalonDetailScreen**: Salon information and stylists
- **StylistProfileScreen**: Stylist details, portfolio, reviews
- **BookingFlowScreen**: Multi-step booking process
  1. Select service
  2. Choose date
  3. Pick time slot
  4. Payment & confirmation

### AI Features
- **AIPreviewScreen**: Upload photo for AI-generated style previews

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

## Future Enhancements

- [ ] Complete Firebase authentication integration
- [ ] Add real-time chat with stylists
- [ ] Implement push notifications
- [ ] Add payment processing with Stripe
- [ ] Integrate AI styling service (Nano Banana)
- [ ] Add favorites/bookmarks
- [ ] Implement review system
- [ ] Add location-based search
- [ ] Social sharing features
- [ ] Dark mode support

## Contributing

1. Follow Flutter style guide
2. Run `flutter analyze` before committing
3. Format code with `flutter format .`
4. Update tests for new features

## License

Copyright © 2025 Zelux. All rights reserved.

