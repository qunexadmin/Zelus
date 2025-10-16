import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/screens/login_screen.dart';
import '../../features/screens/home_screen.dart';
import '../../features/screens/salon_detail_screen.dart';
import '../../features/screens/ai_preview_screen.dart';
import '../../features/screens/stylist_onboard_screen.dart';
import '../../features/screens/explore_screen.dart';
import '../../features/screens/pro_profile_screen.dart';
import '../../features/screens/collections_screen.dart';
import '../../features/screens/trending_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
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
          return ProProfileScreen(proId: stylistId);
        },
      ),
      GoRoute(
        path: '/ai-preview',
        name: 'ai-preview',
        builder: (context, state) => const AIPreviewScreen(),
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

