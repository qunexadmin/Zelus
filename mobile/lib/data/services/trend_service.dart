import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/feature_flags.dart';

/// Trend Source Adapter
/// Fetches trending content from external platforms
class TrendService {
  final Dio _dio;

  TrendService(this._dio);

  /// Get trending hashtags
  Future<List<String>> getTrendingHashtags() async {
    if (FeatureFlags.mockData) {
      return _getMockTrendingHashtags();
    }

    try {
      final response = await _dio.get('/trends/hashtags');
      final List<dynamic> data = response.data;
      return data.cast<String>();
    } catch (e) {
      print('Error fetching trending hashtags: $e');
      return _getMockTrendingHashtags();
    }
  }

  /// Get trending services
  Future<List<String>> getTrendingServices() async {
    if (FeatureFlags.mockData) {
      return _getMockTrendingServices();
    }

    try {
      final response = await _dio.get('/trends/services');
      final List<dynamic> data = response.data;
      return data.cast<String>();
    } catch (e) {
      print('Error fetching trending services: $e');
      return _getMockTrendingServices();
    }
  }

  /// Get trending content from Instagram (mock for now)
  Future<List<String>> getInstagramTrends() async {
    // TODO: Implement actual Instagram oEmbed integration
    return [
      'https://www.instagram.com/p/mock1/',
      'https://www.instagram.com/p/mock2/',
    ];
  }

  /// Get trending content from TikTok (mock for now)
  Future<List<String>> getTikTokTrends() async {
    // TODO: Implement actual TikTok oEmbed integration
    return [
      'https://www.tiktok.com/@user/video/mock1',
      'https://www.tiktok.com/@user/video/mock2',
    ];
  }

  /// Get trending content from Pinterest (mock for now)
  Future<List<String>> getPinterestTrends() async {
    // TODO: Implement actual Pinterest integration
    return [
      'https://www.pinterest.com/pin/mock1/',
      'https://www.pinterest.com/pin/mock2/',
    ];
  }

  /// Mock trending hashtags
  List<String> _getMockTrendingHashtags() {
    return [
      '#balayage',
      '#hairtransformation',
      '#summerhair',
      '#blondehighlights',
      '#hairstyles2025',
      '#beautysalon',
      '#hairstylist',
      '#haircolor',
    ];
  }

  /// Mock trending services
  List<String> _getMockTrendingServices() {
    return [
      'Balayage',
      'Highlights',
      'Keratin Treatment',
      'Hair Extensions',
      'Color Correction',
    ];
  }
}

/// Riverpod Provider
final trendServiceProvider = Provider<TrendService>((ref) {
  final dio = ref.watch(dioProvider);
  return TrendService(dio);
});

/// Trending hashtags provider
final trendingHashtagsProvider = FutureProvider.autoDispose<List<String>>((ref) {
  final service = ref.watch(trendServiceProvider);
  return service.getTrendingHashtags();
});

/// Trending services provider
final trendingServicesProvider = FutureProvider.autoDispose<List<String>>((ref) {
  final service = ref.watch(trendServiceProvider);
  return service.getTrendingServices();
});

