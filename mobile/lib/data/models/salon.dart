import 'package:freezed_annotation/freezed_annotation.dart';

part 'salon.freezed.dart';
part 'salon.g.dart';

/// Salon Model
/// Represents a beauty salon/business location
@freezed
class Salon with _$Salon {
  const factory Salon({
    required String id,
    required String name,
    required String address,
    String? city,
    String? state,
    @JsonKey(name: 'zip_code') String? zipCode,
    double? latitude,
    double? longitude,
    @Default([]) List<String> services,
    String? phone,
    String? email,
    String? website,
    @JsonKey(name: 'booking_url') String? bookingUrl,
    @Default([]) List<String> staffIds,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @Default([]) List<String> photos,
    @Default(0.0) double rating,
    @JsonKey(name: 'review_count') @Default(0) int reviewCount,
    String? description,
    Map<String, String>? hours,
    @Default([]) List<String> amenities,
    @JsonKey(name: 'is_active') @Default(false) bool isVerified,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Salon;

  factory Salon.fromJson(Map<String, dynamic> json) => _$SalonFromJson(json);
}

