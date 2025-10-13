import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/feature_flags.dart';
import '../models/oembed_data.dart';

/// oEmbed Service
/// Fetches embeddable content from external platforms (Instagram, TikTok)
class OEmbedService {
  final Dio _dio;

  OEmbedService(this._dio);

  /// Fetch oEmbed data for a URL
  Future<OEmbedData?> fetch(String url) async {
    if (FeatureFlags.mockData) {
      return _getMockOEmbedData(url);
    }

    try {
      final platform = _detectPlatform(url);
      final endpoint = _getOEmbedEndpoint(platform, url);

      if (endpoint == null) {
        print('Unsupported platform for URL: $url');
        return null;
      }

      final response = await _dio.get(endpoint);
      final data = response.data;

      return OEmbedData(
        url: url,
        platform: platform,
        html: data['html'] ?? '',
        title: data['title'],
        authorName: data['author_name'],
        authorUrl: data['author_url'],
        thumbnailUrl: data['thumbnail_url'],
        width: data['width'],
        height: data['height'],
        fetchedAt: DateTime.now(),
      );
    } catch (e) {
      print('Error fetching oEmbed data: $e');
      return _getMockOEmbedData(url);
    }
  }

  /// Detect platform from URL
  String _detectPlatform(String url) {
    if (url.contains('instagram.com')) {
      return 'instagram';
    } else if (url.contains('tiktok.com')) {
      return 'tiktok';
    } else if (url.contains('pinterest.com')) {
      return 'pinterest';
    }
    return 'unknown';
  }

  /// Get oEmbed endpoint for platform
  String? _getOEmbedEndpoint(String platform, String url) {
    switch (platform) {
      case 'instagram':
        return 'https://graph.facebook.com/v12.0/instagram_oembed?url=${Uri.encodeComponent(url)}&access_token=YOUR_TOKEN';
      case 'tiktok':
        return 'https://www.tiktok.com/oembed?url=${Uri.encodeComponent(url)}';
      case 'pinterest':
        return 'https://www.pinterest.com/oembed.json?url=${Uri.encodeComponent(url)}';
      default:
        return null;
    }
  }

  /// Get mock oEmbed data
  OEmbedData _getMockOEmbedData(String url) {
    final platform = _detectPlatform(url);
    return OEmbedData(
      url: url,
      platform: platform,
      html: '<blockquote><p>Mock embedded post</p></blockquote>',
      title: 'Mock $platform Post',
      authorName: '@mockuser',
      authorUrl: 'https://$platform.com/mockuser',
      thumbnailUrl: 'https://via.placeholder.com/300',
      width: 400,
      height: 600,
      fetchedAt: DateTime.now(),
    );
  }
}

/// Riverpod Provider
final oembedServiceProvider = Provider<OEmbedService>((ref) {
  final dio = ref.watch(dioProvider);
  return OEmbedService(dio);
});

/// Fetch oEmbed provider
final oembedProvider =
    FutureProvider.autoDispose.family<OEmbedData?, String>((ref, url) {
  final service = ref.watch(oembedServiceProvider);
  return service.fetch(url);
});

