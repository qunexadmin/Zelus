import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/feature_flags.dart';

/// Personalization Store
/// Tracks user signals for lightweight on-device personalization
class PersonalizationStore {
  static const String _keySearchTerms = 'personalization_search_terms';
  static const String _keySavedPosts = 'personalization_saved_posts';
  static const String _keyFollowedIds = 'personalization_followed_ids';
  static const String _keyLastCity = 'personalization_last_city';
  static const String _keyViewedPosts = 'personalization_viewed_posts';
  static const String _keyLikedTags = 'personalization_liked_tags';

  final SharedPreferences _prefs;

  PersonalizationStore(this._prefs);

  // Search Terms
  Future<List<String>> getSearchTerms() async {
    return _prefs.getStringList(_keySearchTerms) ?? [];
  }

  Future<void> addSearchTerm(String term) async {
    final terms = await getSearchTerms();
    if (!terms.contains(term)) {
      terms.insert(0, term);
      if (terms.length > 50) terms.removeLast(); // Keep last 50
      await _prefs.setStringList(_keySearchTerms, terms);
    }
  }

  // Saved Posts
  Future<List<String>> getSavedPosts() async {
    return _prefs.getStringList(_keySavedPosts) ?? [];
  }

  Future<void> savePost(String postId) async {
    final posts = await getSavedPosts();
    if (!posts.contains(postId)) {
      posts.insert(0, postId);
      await _prefs.setStringList(_keySavedPosts, posts);
    }
  }

  Future<void> unsavePost(String postId) async {
    final posts = await getSavedPosts();
    posts.remove(postId);
    await _prefs.setStringList(_keySavedPosts, posts);
  }

  // Followed IDs
  Future<List<String>> getFollowedIds() async {
    return _prefs.getStringList(_keyFollowedIds) ?? [];
  }

  Future<void> followUser(String userId) async {
    final followed = await getFollowedIds();
    if (!followed.contains(userId)) {
      followed.add(userId);
      await _prefs.setStringList(_keyFollowedIds, followed);
    }
  }

  Future<void> unfollowUser(String userId) async {
    final followed = await getFollowedIds();
    followed.remove(userId);
    await _prefs.setStringList(_keyFollowedIds, followed);
  }

  // Last City
  Future<String?> getLastCity() async {
    return _prefs.getString(_keyLastCity);
  }

  Future<void> setLastCity(String city) async {
    await _prefs.setString(_keyLastCity, city);
  }

  // Viewed Posts (for recency scoring)
  Future<List<String>> getViewedPosts() async {
    return _prefs.getStringList(_keyViewedPosts) ?? [];
  }

  Future<void> addViewedPost(String postId) async {
    final viewed = await getViewedPosts();
    viewed.remove(postId); // Remove if exists
    viewed.insert(0, postId); // Add to front
    if (viewed.length > 100) viewed.removeLast(); // Keep last 100
    await _prefs.setStringList(_keyViewedPosts, viewed);
  }

  // Liked Tags (for tag-based recommendations)
  Future<Map<String, int>> getLikedTags() async {
    final List<String> encoded = _prefs.getStringList(_keyLikedTags) ?? [];
    final Map<String, int> tags = {};
    for (final item in encoded) {
      final parts = item.split(':');
      if (parts.length == 2) {
        tags[parts[0]] = int.tryParse(parts[1]) ?? 0;
      }
    }
    return tags;
  }

  Future<void> incrementTagScore(String tag) async {
    final tags = await getLikedTags();
    tags[tag] = (tags[tag] ?? 0) + 1;
    
    // Encode back to list
    final encoded = tags.entries.map((e) => '${e.key}:${e.value}').toList();
    await _prefs.setStringList(_keyLikedTags, encoded);
  }

  /// Score an item based on personalization signals
  /// Returns a score 0-100 where higher = more relevant
  Future<double> scoreItem({
    required List<String> itemTags,
    String? itemLocation,
    required DateTime itemCreatedAt,
  }) async {
    if (!FeatureFlags.personalization) {
      return 50.0; // Neutral score if personalization disabled
    }

    double score = 0.0;

    // Tag overlap (0-40 points)
    final likedTags = await getLikedTags();
    final searchTerms = await getSearchTerms();
    
    for (final tag in itemTags) {
      if (likedTags.containsKey(tag)) {
        score += (likedTags[tag]! * 2).clamp(0, 10);
      }
      if (searchTerms.contains(tag)) {
        score += 5;
      }
    }
    score = score.clamp(0, 40);

    // Location match (0-20 points)
    final lastCity = await getLastCity();
    if (itemLocation != null && lastCity != null) {
      if (itemLocation.toLowerCase().contains(lastCity.toLowerCase())) {
        score += 20;
      }
    }

    // Recency (0-20 points)
    final daysSinceCreated = DateTime.now().difference(itemCreatedAt).inDays;
    if (daysSinceCreated <= 1) {
      score += 20;
    } else if (daysSinceCreated <= 7) {
      score += 15;
    } else if (daysSinceCreated <= 30) {
      score += 10;
    }

    // Base popularity (0-20 points) - can be passed from item
    score += 10; // Default base score

    return score.clamp(0, 100);
  }

  /// Clear all personalization data
  Future<void> clearAll() async {
    await _prefs.remove(_keySearchTerms);
    await _prefs.remove(_keySavedPosts);
    await _prefs.remove(_keyFollowedIds);
    await _prefs.remove(_keyLastCity);
    await _prefs.remove(_keyViewedPosts);
    await _prefs.remove(_keyLikedTags);
  }
}

/// Riverpod Provider
final personalizationStoreProvider = FutureProvider<PersonalizationStore>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return PersonalizationStore(prefs);
});

