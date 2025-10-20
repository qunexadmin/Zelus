import 'package:freezed_annotation/freezed_annotation.dart';

part 'pro_profile.freezed.dart';
part 'pro_profile.g.dart';

/// Professional Profile Model
/// Represents a beauty professional (stylist, makeup artist, etc.)
@freezed
class ProProfile with _$ProProfile {
  const factory ProProfile({
    required String id,
    required String name,
    @JsonKey(name: 'profile_image_url') String? photoUrl,
    required String bio,
    @Default([]) List<String> specialties,
    @JsonKey(name: 'base_price') double? priceRange,
    @Default([]) List<String> languages,
    @Default(0.0) double rating,
    @JsonKey(name: 'review_count') @Default(0) int reviewCount,
    @JsonKey(name: 'portfolio_images') @Default([]) List<String> portfolio,
    @JsonKey(name: 'salon_id') String? salonId,
    @JsonKey(name: 'salon_name') String? salonName,
    String? location,
    @JsonKey(name: 'booking_url') String? bookingUrl,
    @Default([]) List<String> services,  // Services array from API
    @JsonKey(name: 'years_experience') @Default(0) int yearsExperience,
    @Default(0) int followerCount,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ProProfile;

  factory ProProfile.fromJson(Map<String, dynamic> json) =>
      _$ProProfileFromJson(json);
}

