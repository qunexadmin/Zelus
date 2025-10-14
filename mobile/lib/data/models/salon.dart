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
    String? zipCode,
    double? latitude,
    double? longitude,
    @Default([]) List<String> services,
    String? phone,
    String? email,
    String? website,
    String? bookingUrl,
    @Default([]) List<String> staffIds,
    @Default([]) List<String> photos,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    String? description,
    Map<String, String>? hours,
    @Default([]) List<String> amenities,
    @Default(false) bool isVerified,
    DateTime? createdAt,
  }) = _Salon;

  factory Salon.fromJson(Map<String, dynamic> json) => _$SalonFromJson(json);
}

