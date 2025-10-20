import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../models/review.dart';

/// Review Service
/// Handles fetching and submitting reviews
class ReviewService {
  final Dio _dio;

  ReviewService(this._dio);

  /// Get reviews for a target (stylist or salon)
  Future<List<Review>> getReviews(String targetId, String targetType) async {
    final response = await _dio.get('/reviews', queryParameters: {
      'target_id': targetId,
      'target_type': targetType,
    });

    final List<dynamic> data = response.data;
    return data.map((json) => Review.fromJson(json)).toList();
  }

  /// Submit a new review
  Future<Review?> submitReview({
    required String targetId,
    required String targetType,
    required double rating,
    String? text,
    List<String>? photos,
  }) async {
    final response = await _dio.post('/reviews', data: {
      'target_id': targetId,
      'target_type': targetType,
      'rating': rating,
      'text': text,
      'photos': photos,
    });

    return Review.fromJson(response.data);
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

