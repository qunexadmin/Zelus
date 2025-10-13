import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/feature_flags.dart';
import '../models/review.dart';

/// Review Service
/// Handles fetching and submitting reviews
class ReviewService {
  final Dio _dio;

  ReviewService(this._dio);

  /// Get reviews for a target (stylist or salon)
  Future<List<Review>> getReviews(String targetId, String targetType) async {
    if (FeatureFlags.mockData) {
      return _getMockReviews(targetId);
    }

    try {
      final response = await _dio.get('/reviews', queryParameters: {
        'target_id': targetId,
        'target_type': targetType,
      });

      final List<dynamic> data = response.data;
      return data.map((json) => Review.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching reviews: $e');
      return _getMockReviews(targetId);
    }
  }

  /// Submit a new review
  Future<Review?> submitReview({
    required String targetId,
    required String targetType,
    required double rating,
    String? text,
    List<String>? photos,
  }) async {
    try {
      final response = await _dio.post('/reviews', data: {
        'target_id': targetId,
        'target_type': targetType,
        'rating': rating,
        'text': text,
        'photos': photos,
      });

      return Review.fromJson(response.data);
    } catch (e) {
      print('Error submitting review: $e');
      return null;
    }
  }

  /// Load mock reviews from assets
  Future<List<Review>> _getMockReviews(String targetId) async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/mock/reviews.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      final allReviews =
          jsonData.map((json) => Review.fromJson(json)).toList();
      return allReviews.where((r) => r.targetId == targetId).toList();
    } catch (e) {
      print('Error loading mock reviews: $e');
      return _getDefaultReviews();
    }
  }

  /// Default fallback reviews
  List<Review> _getDefaultReviews() {
    return [
      Review(
        id: '1',
        userId: 'user1',
        userName: 'Sarah Johnson',
        targetId: '1',
        targetType: 'stylist',
        rating: 5.0,
        text: 'Amazing color work! Jane really knows what she\'s doing.',
        aiSummary: 'Excellent color expertise. Highly recommended.',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      Review(
        id: '2',
        userId: 'user2',
        userName: 'Mike Brown',
        targetId: '1',
        targetType: 'stylist',
        rating: 4.5,
        text: 'Great experience, very professional.',
        aiSummary: 'Professional service with great results.',
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
    ];
  }
}

/// Riverpod Provider
final reviewServiceProvider = Provider<ReviewService>((ref) {
  final dio = ref.watch(dioProvider);
  return ReviewService(dio);
});

/// Get reviews provider
final reviewsProvider = FutureProvider.autoDispose
    .family<List<Review>, Map<String, String>>((ref, params) {
  final service = ref.watch(reviewServiceProvider);
  return service.getReviews(params['targetId']!, params['targetType']!);
});

