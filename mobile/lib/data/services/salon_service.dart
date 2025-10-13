import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/feature_flags.dart';
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
    if (FeatureFlags.mockData) {
      return _getMockSalons();
    }

    try {
      final response = await _dio.get('/salons', queryParameters: {
        if (city != null) 'city': city,
        if (service != null) 'service': service,
        if (minRating != null) 'min_rating': minRating,
      });

      final List<dynamic> data = response.data;
      return data.map((json) => Salon.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching salons: $e');
      return _getMockSalons();
    }
  }

  /// Get a single salon by ID
  Future<Salon?> getSalon(String id) async {
    if (FeatureFlags.mockData) {
      final salons = await _getMockSalons();
      return salons.firstWhere((s) => s.id == id, orElse: () => salons.first);
    }

    try {
      final response = await _dio.get('/salons/$id');
      return Salon.fromJson(response.data);
    } catch (e) {
      print('Error fetching salon: $e');
      return null;
    }
  }

  /// Load mock salons from assets
  Future<List<Salon>> _getMockSalons() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/mock/salons.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => Salon.fromJson(json)).toList();
    } catch (e) {
      print('Error loading mock salons: $e');
      return _getDefaultSalons();
    }
  }

  /// Default fallback salons
  List<Salon> _getDefaultSalons() {
    return [
      const Salon(
        id: 'salon1',
        name: 'Elite Hair Studio',
        address: '123 Main St',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        services: ['Haircut', 'Color', 'Styling'],
        phone: '(212) 555-0100',
        staffIds: ['1'],
        rating: 4.7,
        reviewCount: 256,
        description: 'Upscale salon in the heart of Manhattan',
        isVerified: true,
      ),
      const Salon(
        id: 'salon2',
        name: 'Modern Cuts',
        address: '456 Market St',
        city: 'San Francisco',
        state: 'CA',
        zipCode: '94102',
        services: ['Haircut', 'Beard', 'Styling'],
        phone: '(415) 555-0200',
        staffIds: ['2'],
        rating: 4.8,
        reviewCount: 189,
        description: 'Contemporary styling for modern individuals',
        isVerified: true,
      ),
    ];
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

