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
    required String photoUrl,
    required String bio,
    @Default([]) List<String> services,
    String? priceRange,
    @Default([]) List<String> languages,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default([]) List<String> portfolio,
    String? salonId,
    String? salonName,
    String? location,
    @Default([]) List<String> specialties,
    @Default(0) int yearsExperience,
    @Default(0) int followerCount,
    @Default(false) bool isVerified,
    DateTime? createdAt,
  }) = _ProProfile;

  factory ProProfile.fromJson(Map<String, dynamic> json) =>
      _$ProProfileFromJson(json);
}

