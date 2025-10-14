import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/salons/presentation/screens/salon_detail_screen.dart';
import '../../features/stylists/presentation/screens/stylist_profile_screen.dart';
import '../../features/bookings/presentation/screens/booking_flow_screen.dart';
import '../../features/ai_preview/presentation/screens/ai_preview_screen.dart';
import '../../features/feed/presentation/screens/reels_screen.dart';
import '../../features/stylists/presentation/screens/stylist_onboard_screen.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/pros/presentation/screens/pro_profile_screen.dart';
import '../../features/upload/presentation/screens/upload_screen.dart';
import '../../features/collections/presentation/screens/collections_screen.dart';
import '../../features/trending/presentation/screens/trending_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/salon/:id',
        name: 'salon-detail',
        builder: (context, state) {
          final salonId = state.pathParameters['id']!;
          return SalonDetailScreen(salonId: salonId);
        },
      ),
      GoRoute(
        path: '/stylist/:id',
        name: 'stylist-profile',
        builder: (context, state) {
          final stylistId = state.pathParameters['id']!;
          return StylistProfileScreen(stylistId: stylistId);
        },
      ),
      GoRoute(
        path: '/booking',
        name: 'booking-flow',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return BookingFlowScreen(
            stylistId: extra?['stylistId'],
            serviceId: extra?['serviceId'],
          );
        },
      ),
      GoRoute(
        path: '/ai-preview',
        name: 'ai-preview',
        builder: (context, state) => const AIPreviewScreen(),
      ),
      GoRoute(
        path: '/reels',
        name: 'reels',
        builder: (context, state) => const ReelsScreen(),
      ),
      GoRoute(
        path: '/stylist-onboard',
        name: 'stylist-onboard',
        builder: (context, state) => const StylistOnboardScreen(),
      ),
      GoRoute(
        path: '/explore',
        name: 'explore',
        builder: (context, state) => const ExploreScreen(),
      ),
      GoRoute(
        path: '/pros/:id',
        name: 'pro-profile',
        builder: (context, state) {
          final proId = state.pathParameters['id']!;
          return ProProfileScreen(proId: proId);
        },
      ),
      GoRoute(
        path: '/upload',
        name: 'upload',
        builder: (context, state) => const UploadScreen(),
      ),
      GoRoute(
        path: '/collections',
        name: 'collections',
        builder: (context, state) => const CollectionsScreen(),
      ),
      GoRoute(
        path: '/trending',
        name: 'trending',
        builder: (context, state) => const TrendingScreen(),
      ),
    ],
  );
});

