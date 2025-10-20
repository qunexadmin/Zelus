import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../models/salon.dart';

/// Salon Service
/// Handles fetching and managing salon data
class SalonService {
  final Dio _dio;

  SalonService(this._dio);

  /// Get all salons
  Future<List<Salon>> getSalons({
    String? city,
    String? service,
    double? minRating,
  }) async {
    final response = await _dio.get('/salons', queryParameters: {
      if (city != null) 'city': city,
      if (service != null) 'service': service,
      if (minRating != null) 'min_rating': minRating,
    });

    // API returns {"salons": [...], "total": N}
    final List<dynamic> data = response.data['salons'] ?? [];
    return data.map((json) => Salon.fromJson(json)).toList();
  }

  /// Get a single salon by ID
  Future<Salon?> getSalon(String id) async {
    final response = await _dio.get('/salons/$id');
    return Salon.fromJson(response.data);
  }
}

/// Riverpod Provider
final salonServiceProvider = Provider<SalonService>((ref) {
  final dio = ref.watch(dioProvider);
  return SalonService(dio);
});

/// Get all salons provider
final salonsProvider = FutureProvider.autoDispose<List<Salon>>((ref) {
  final service = ref.watch(salonServiceProvider);
  return service.getSalons();
});

/// Get single salon provider
final salonProvider =
    FutureProvider.autoDispose.family<Salon?, String>((ref, id) {
  final service = ref.watch(salonServiceProvider);
  return service.getSalon(id);
});

