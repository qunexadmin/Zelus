import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
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
    final response = await _dio.get('/pros', queryParameters: {
      if (city != null) 'city': city,
      if (service != null) 'service': service,
      if (minRating != null) 'min_rating': minRating,
    });

    final List<dynamic> data = response.data;
    return data.map((json) => ProProfile.fromJson(json)).toList();
  }

  /// Get a single professional profile by ID
  Future<ProProfile?> getProfile(String id) async {
    final response = await _dio.get('/pros/$id');
    return ProProfile.fromJson(response.data);
  }

  /// Get profiles by salon
  Future<List<ProProfile>> getProfilesBySalon(String salonId) async {
    final response = await _dio.get('/salons/$salonId/staff');
    final List<dynamic> data = response.data;
    return data.map((json) => ProProfile.fromJson(json)).toList();
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

