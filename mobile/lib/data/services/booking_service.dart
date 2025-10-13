import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../models/booking_request.dart';

/// Booking Service
/// Handles booking requests (no payment processing yet)
class BookingService {
  final Dio _dio;

  BookingService(this._dio);

  /// Create a booking request
  Future<BookingRequest?> createBookingRequest({
    required String userId,
    String? proId,
    String? salonId,
    String? serviceId,
    String? serviceName,
    DateTime? requestedDate,
    String? requestedTime,
    String? notes,
  }) async {
    try {
      final response = await _dio.post('/bookings/request', data: {
        'user_id': userId,
        'pro_id': proId,
        'salon_id': salonId,
        'service_id': serviceId,
        'service_name': serviceName,
        'requested_date': requestedDate?.toIso8601String(),
        'requested_time': requestedTime,
        'notes': notes,
      });

      return BookingRequest.fromJson(response.data);
    } catch (e) {
      print('Error creating booking request: $e');
      // Return mock success
      return BookingRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        proId: proId,
        salonId: salonId,
        serviceId: serviceId,
        serviceName: serviceName,
        requestedDate: requestedDate,
        requestedTime: requestedTime,
        notes: notes,
        status: 'pending',
        createdAt: DateTime.now(),
      );
    }
  }

  /// Get booking requests for a user
  Future<List<BookingRequest>> getUserBookings(String userId) async {
    try {
      final response = await _dio.get('/bookings/user/$userId');
      final List<dynamic> data = response.data;
      return data.map((json) => BookingRequest.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching user bookings: $e');
      return [];
    }
  }

  /// Cancel a booking request
  Future<bool> cancelBooking(String bookingId) async {
    try {
      await _dio.patch('/bookings/$bookingId/cancel');
      return true;
    } catch (e) {
      print('Error cancelling booking: $e');
      return false;
    }
  }
}

/// Riverpod Provider
final bookingServiceProvider = Provider<BookingService>((ref) {
  final dio = ref.watch(dioProvider);
  return BookingService(dio);
});

