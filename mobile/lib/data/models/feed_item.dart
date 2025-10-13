import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_item.freezed.dart';
part 'feed_item.g.dart';

/// Feed Item Model
/// Represents a post in the social feed (photo or video)
@freezed
class FeedItem with _$FeedItem {
  const factory FeedItem({
    required String id,
    required String creatorId,
    required String creatorName,
    String? creatorPhotoUrl,
    required String mediaType, // 'photo' or 'video'
    required String mediaUrl,
    String? thumbnailUrl, // for videos
    String? caption,
    @Default([]) List<String> tags,
    @Default([]) List<String> hashtags,
    String? serviceType,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
    @Default(0) int saveCount,
    @Default(0) int viewCount,
    @Default(false) bool isLiked,
    @Default(false) bool isSaved,
    DateTime? createdAt,
    String? location,
    // External source info (for trending posts from Instagram/TikTok)
    String? externalSource, // 'instagram' or 'tiktok'
    String? externalUrl,
    String? externalHandle,
  }) = _FeedItem;

  factory FeedItem.fromJson(Map<String, dynamic> json) =>
      _$FeedItemFromJson(json);
}

