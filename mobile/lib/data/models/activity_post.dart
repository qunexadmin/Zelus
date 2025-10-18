import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_post.freezed.dart';
part 'activity_post.g.dart';

/// Activity Post Types
enum ActivityPostType {
  portfolioUpload,
  promotion,
  newService,
  locationChange,
}

/// Activity Post Model
/// Represents a post in the activity feed from followed stylists
@freezed
class ActivityPost with _$ActivityPost {
  const factory ActivityPost({
    required String id,
    required String stylistId,
    required String stylistName,
    required String stylistPhotoUrl,
    String? salonName, // For employed stylists
    required ActivityPostType type,
    required String content,
    String? imageUrl,
    List<String>? images, // For portfolio posts with multiple images
    String? previousLocation, // For location changes
    String? newLocation, // For location changes
    String? serviceName, // For new services
    double? servicePrice, // For new services
    String? promotionDetails, // For promotions
    required DateTime createdAt,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
  }) = _ActivityPost;

  factory ActivityPost.fromJson(Map<String, dynamic> json) =>
      _$ActivityPostFromJson(json);
}

/// Extension for display helpers
extension ActivityPostExtension on ActivityPost {
  /// Get display title based on post type
  String get displayTitle {
    switch (type) {
      case ActivityPostType.portfolioUpload:
        return 'New Portfolio Upload';
      case ActivityPostType.promotion:
        return 'Special Promotion';
      case ActivityPostType.newService:
        return 'New Service Available';
      case ActivityPostType.locationChange:
        return 'Location Update';
    }
  }

  /// Get icon data based on post type
  String get iconEmoji {
    switch (type) {
      case ActivityPostType.portfolioUpload:
        return '✨';
      case ActivityPostType.promotion:
        return '🎉';
      case ActivityPostType.newService:
        return '💇';
      case ActivityPostType.locationChange:
        return '📍';
    }
  }

  /// Format the stylist info with salon if available
  String get stylistInfo {
    if (salonName != null) {
      return '$stylistName at $salonName';
    }
    return stylistName;
  }

  /// Format time ago
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inDays > 30) {
      return '${diff.inDays ~/ 30}mo ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

