import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/feature_flags.dart';
import '../models/pro_profile.dart';

/// Professional Profile Service
/// Handles fetching and managing professional profiles
class ProfileService {
  final Dio _dio;

  ProfileService(this._dio);

  /// Get all professional profiles
  Future<List<ProProfile>> getProfiles({
    String? city,
    String? service,
    double? minRating,
  }) async {
    if (FeatureFlags.mockData) {
      return _getMockProfiles();
    }

    try {
      final response = await _dio.get('/pros', queryParameters: {
        if (city != null) 'city': city,
        if (service != null) 'service': service,
        if (minRating != null) 'min_rating': minRating,
      });

      final List<dynamic> data = response.data;
      return data.map((json) => ProProfile.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching profiles: $e');
      return _getMockProfiles();
    }
  }

  /// Get a single professional profile by ID
  Future<ProProfile?> getProfile(String id) async {
    if (FeatureFlags.mockData) {
      final profiles = await _getMockProfiles();
      return profiles.firstWhere((p) => p.id == id,
          orElse: () => profiles.first);
    }

    try {
      final response = await _dio.get('/pros/$id');
      return ProProfile.fromJson(response.data);
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  /// Get profiles by salon
  Future<List<ProProfile>> getProfilesBySalon(String salonId) async {
    if (FeatureFlags.mockData) {
      final profiles = await _getMockProfiles();
      return profiles.where((p) => p.salonId == salonId).toList();
    }

    try {
      final response = await _dio.get('/salons/$salonId/staff');
      final List<dynamic> data = response.data;
      return data.map((json) => ProProfile.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching salon profiles: $e');
      return [];
    }
  }

  /// Load mock profiles from assets
  Future<List<ProProfile>> _getMockProfiles() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/mock/profiles.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => ProProfile.fromJson(json)).toList();
    } catch (e) {
      print('Error loading mock profiles: $e');
      return _getDefaultProfiles();
    }
  }

  /// Default fallback profiles
  List<ProProfile> _getDefaultProfiles() {
    return [
      const ProProfile(
        id: '1',
        name: 'Jane Smith',
        photoUrl: 'https://via.placeholder.com/150',
        bio: 'Expert colorist with 10+ years experience',
        services: ['Color', 'Balayage', 'Highlights'],
        priceRange: '\$\$-\$\$\$',
        languages: ['English', 'Spanish'],
        rating: 4.8,
        reviewCount: 124,
        portfolio: [],
        salonId: 'salon1',
        salonName: 'Elite Hair Studio',
        location: 'New York, NY',
        yearsExperience: 10,
        isVerified: true,
      ),
      const ProProfile(
        id: '2',
        name: 'Michael Chen',
        photoUrl: 'https://via.placeholder.com/150',
        bio: 'Master stylist specializing in modern cuts',
        services: ['Haircut', 'Styling', 'Texture'],
        priceRange: '\$\$',
        languages: ['English', 'Mandarin'],
        rating: 4.9,
        reviewCount: 89,
        portfolio: [],
        salonId: 'salon2',
        salonName: 'Modern Cuts',
        location: 'San Francisco, CA',
        yearsExperience: 8,
        isVerified: true,
      ),
    ];
  }
}

/// Riverpod Provider
final profileServiceProvider = Provider<ProfileService>((ref) {
  final dio = ref.watch(dioProvider);
  return ProfileService(dio);
});

/// Get all profiles provider
final profilesProvider = FutureProvider.autoDispose<List<ProProfile>>((ref) {
  final service = ref.watch(profileServiceProvider);
  return service.getProfiles();
});

/// Get single profile provider
final profileProvider =
    FutureProvider.autoDispose.family<ProProfile?, String>((ref, id) {
  final service = ref.watch(profileServiceProvider);
  return service.getProfile(id);
});

