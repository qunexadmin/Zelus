import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/feature_flags.dart';
import '../models/feed_item.dart';

/// Feed Service
/// Handles fetching social feed content
class FeedService {
  final Dio _dio;

  FeedService(this._dio);

  /// Get personalized "For You" feed
  Future<List<FeedItem>> getForYouFeed({int page = 0, int limit = 20}) async {
    if (FeatureFlags.mockData) {
      return _getMockFeed();
    }

    try {
      final response = await _dio.get('/feed/for-you', queryParameters: {
        'page': page,
        'limit': limit,
      });

      final List<dynamic> data = response.data;
      return data.map((json) => FeedItem.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching for you feed: $e');
      return _getMockFeed();
    }
  }

  /// Get "Trending Now" feed
  Future<List<FeedItem>> getTrendingFeed({int page = 0, int limit = 20}) async {
    if (FeatureFlags.mockData) {
      return _getMockFeed();
    }

    try {
      final response = await _dio.get('/feed/trending', queryParameters: {
        'page': page,
        'limit': limit,
      });

      final List<dynamic> data = response.data;
      return data.map((json) => FeedItem.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching trending feed: $e');
      return _getMockFeed();
    }
  }

  /// Get following feed
  Future<List<FeedItem>> getFollowingFeed(
      {int page = 0, int limit = 20}) async {
    if (FeatureFlags.mockData) {
      return _getMockFeed();
    }

    try {
      final response = await _dio.get('/feed/following', queryParameters: {
        'page': page,
        'limit': limit,
      });

      final List<dynamic> data = response.data;
      return data.map((json) => FeedItem.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching following feed: $e');
      return _getMockFeed();
    }
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

  /// Load mock feed from assets
  Future<List<FeedItem>> _getMockFeed() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/mock/feeds.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => FeedItem.fromJson(json)).toList();
    } catch (e) {
      print('Error loading mock feed: $e');
      return _getDefaultFeed();
    }
  }

  /// Default fallback feed
  List<FeedItem> _getDefaultFeed() {
    return [
      FeedItem(
        id: '1',
        creatorId: '1',
        creatorName: 'Jane Smith',
        mediaType: 'photo',
        mediaUrl: 'https://via.placeholder.com/400',
        caption: 'Fresh balayage transformation 💇‍♀️✨',
        tags: ['balayage', 'hair color'],
        hashtags: ['#balayage', '#hairtransformation'],
        serviceType: 'Color',
        likeCount: 245,
        commentCount: 18,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      FeedItem(
        id: '2',
        creatorId: '2',
        creatorName: 'Michael Chen',
        mediaType: 'photo',
        mediaUrl: 'https://via.placeholder.com/400',
        caption: 'Modern fade ✂️ #barbershop',
        tags: ['fade', 'mens cut'],
        hashtags: ['#fade', '#barbershop'],
        serviceType: 'Haircut',
        likeCount: 189,
        commentCount: 12,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
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

