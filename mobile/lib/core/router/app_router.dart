import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/salons/presentation/screens/salon_detail_screen.dart';
import '../../features/stylists/presentation/screens/stylist_profile_screen.dart';
import '../../features/bookings/presentation/screens/booking_flow_screen.dart';
import '../../features/ai_preview/presentation/screens/ai_preview_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
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
    ],
  );
});

