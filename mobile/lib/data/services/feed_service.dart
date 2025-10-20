import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../models/feed_item.dart';

/// Feed Service
/// Handles fetching social feed content
class FeedService {
  final Dio _dio;

  FeedService(this._dio);

  /// Get personalized "For You" feed
  Future<List<FeedItem>> getForYouFeed({int page = 0, int limit = 20}) async {
    final response = await _dio.get('/feed/for-you', queryParameters: {
      'page': page,
      'limit': limit,
    });

    final List<dynamic> data = response.data;
    return data.map((json) => FeedItem.fromJson(json)).toList();
  }

  /// Get "Trending Now" feed
  Future<List<FeedItem>> getTrendingFeed({int page = 0, int limit = 20}) async {
    final response = await _dio.get('/feed/trending', queryParameters: {
      'page': page,
      'limit': limit,
    });

    final List<dynamic> data = response.data;
    return data.map((json) => FeedItem.fromJson(json)).toList();
  }

  /// Get following feed
  Future<List<FeedItem>> getFollowingFeed(
      {int page = 0, int limit = 20}) async {
    final response = await _dio.get('/feed/following', queryParameters: {
      'page': page,
      'limit': limit,
    });

    final List<dynamic> data = response.data;
    return data.map((json) => FeedItem.fromJson(json)).toList();
  }

  /// Like a post
  Future<void> likePost(String postId) async {
    try {
      await _dio.post('/feed/$postId/like');
    } catch (e) {
      print('Error liking post: $e');
    }
  }

  /// Unlike a post
  Future<void> unlikePost(String postId) async {
    try {
      await _dio.delete('/feed/$postId/like');
    } catch (e) {
      print('Error unliking post: $e');
    }
  }

  /// Save a post
  Future<void> savePost(String postId) async {
    try {
      await _dio.post('/feed/$postId/save');
    } catch (e) {
      print('Error saving post: $e');
    }
  }

  /// Unsave a post
  Future<void> unsavePost(String postId) async {
    try {
      await _dio.delete('/feed/$postId/save');
    } catch (e) {
      print('Error unsaving post: $e');
    }
  }
}

/// Riverpod Provider
final feedServiceProvider = Provider<FeedService>((ref) {
  final dio = ref.watch(dioProvider);
  return FeedService(dio);
});

/// For You feed provider
final forYouFeedProvider = FutureProvider.autoDispose<List<FeedItem>>((ref) {
  final service = ref.watch(feedServiceProvider);
  return service.getForYouFeed();
});

/// Trending feed provider
final trendingFeedProvider = FutureProvider.autoDispose<List<FeedItem>>((ref) {
  final service = ref.watch(feedServiceProvider);
  return service.getTrendingFeed();
});

/// Following feed provider
final followingFeedProvider =
    FutureProvider.autoDispose<List<FeedItem>>((ref) {
  final service = ref.watch(feedServiceProvider);
  return service.getFollowingFeed();
});

