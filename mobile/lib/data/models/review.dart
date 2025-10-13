import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

/// Review Model
/// Represents a customer review/rating
@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    required String userId,
    String? userName,
    String? userPhotoUrl,
    required String targetId, // stylist or salon ID
    required String targetType, // 'stylist' or 'salon'
    required double rating, // 1-5 stars
    String? text,
    @Default([]) List<String> photos,
    String? aiSummary, // AI-generated 2-line summary
    DateTime? createdAt,
    @Default(0) int helpfulCount,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}

