import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_request.freezed.dart';
part 'booking_request.g.dart';

/// Booking Request Model
/// Represents a booking request (no payment yet)
@freezed
class BookingRequest with _$BookingRequest {
  const factory BookingRequest({
    required String id,
    required String userId,
    String? proId,
    String? salonId,
    String? serviceId,
    String? serviceName,
    DateTime? requestedDate,
    String? requestedTime,
    String? notes,
    @Default('pending') String status, // pending, confirmed, cancelled
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BookingRequest;

  factory BookingRequest.fromJson(Map<String, dynamic> json) =>
      _$BookingRequestFromJson(json);
}

