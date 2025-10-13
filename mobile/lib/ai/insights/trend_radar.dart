import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/feature_flags.dart';

/// Weekly AI Trend Radar (Stub)
/// Analyzes trending tags, styles, and services
class TrendRadar {
  /// Get weekly trend insights
  Future<TrendInsights> getWeeklyInsights() async {
    if (!FeatureFlags.weeklyTrendRadar) {
      return TrendInsights.empty();
    }

    // TODO: Integrate with AI trend analysis
    print('Fetching weekly trend insights...');
    
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    
    return _getMockInsights();
  }

  /// Get trending tags this week
  Future<List<TrendingTag>> getTrendingTags() async {
    final insights = await getWeeklyInsights();
    return insights.trendingTags;
  }

  /// Get trending styles
  Future<List<String>> getTrendingStyles() async {
    final insights = await getWeeklyInsights();
    return insights.trendingStyles;
  }

  /// Get trending colors
  Future<List<String>> getTrendingColors() async {
    final insights = await getWeeklyInsights();
    return insights.trendingColors;
  }

  /// Mock trend insights
  TrendInsights _getMockInsights() {
    return TrendInsights(
      week: DateTime.now(),
      trendingTags: [
        TrendingTag(tag: 'balayage', growth: 45.2, posts: 1250),
        TrendingTag(tag: 'summer hair', growth: 38.7, posts: 980),
        TrendingTag(tag: 'blonde highlights', growth: 32.1, posts: 850),
        TrendingTag(tag: 'hair transformation', growth: 28.5, posts: 720),
        TrendingTag(tag: 'keratin treatment', growth: 25.3, posts: 650),
      ],
      trendingStyles: [
        'Long layers',
        'Curtain bangs',
        'Shag haircut',
        'Bob with fringe',
        'Textured waves',
      ],
      trendingColors: [
        'Honey blonde',
        'Chocolate brown',
        'Caramel highlights',
        'Platinum blonde',
        'Auburn red',
      ],
      topSalons: [
        'Elite Hair Studio',
        'Modern Cuts',
        'Color Bar NYC',
      ],
      topStylists: [
        'Jane Smith',
        'Michael Chen',
        'Sarah Johnson',
      ],
      insights: [
        'Balayage requests are up 45% this week',
        'Summer-ready styles trending across all regions',
        'Natural color tones gaining popularity',
      ],
    );
  }
}

/// Trend Insights Model
class TrendInsights {
  final DateTime week;
  final List<TrendingTag> trendingTags;
  final List<String> trendingStyles;
  final List<String> trendingColors;
  final List<String> topSalons;
  final List<String> topStylists;
  final List<String> insights;

  TrendInsights({
    required this.week,
    required this.trendingTags,
    required this.trendingStyles,
    required this.trendingColors,
    required this.topSalons,
    required this.topStylists,
    required this.insights,
  });

  factory TrendInsights.empty() {
    return TrendInsights(
      week: DateTime.now(),
      trendingTags: [],
      trendingStyles: [],
      trendingColors: [],
      topSalons: [],
      topStylists: [],
      insights: [],
    );
  }
}

/// Trending Tag Model
class TrendingTag {
  final String tag;
  final double growth; // Percentage growth
  final int posts; // Number of posts

  TrendingTag({
    required this.tag,
    required this.growth,
    required this.posts,
  });
}

/// Riverpod Provider
final trendRadarProvider = Provider<TrendRadar>((ref) {
  return TrendRadar();
});

/// Weekly insights provider
final weeklyInsightsProvider = FutureProvider.autoDispose<TrendInsights>((ref) {
  final radar = ref.watch(trendRadarProvider);
  return radar.getWeeklyInsights();
});

