import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';

class BookingsRemoteDataSource {
  final Dio _dio;

  BookingsRemoteDataSource(this._dio);

  Future<Map<String, dynamic>> createBooking({
    required String listingId,
    String? scheduledDate,
    String? notes,
  }) async {
    final res = await _dio.post(
      ApiConstants.bookings,
      data: {
        'listingId': listingId,
        'scheduledDate': ?scheduledDate,
        'notes': ?notes,
      },
    );
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<List<dynamic>> fetchBookingsList(String path) async {
    final res = await _dio.get(path);
    return res.data['data'] as List;
  }

  Future<Map<String, dynamic>> updateBookingStatus(
    String id,
    String status,
  ) async {
    final res = await _dio.patch(
      '${ApiConstants.bookings}/$id/status',
      data: {'status': status},
    );
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> completeBooking(
    String id, {
    double? amount,
  }) async {
    final res = await _dio.patch(
      '${ApiConstants.bookings}/$id/complete',
      data: amount != null ? {'amountEtb': amount} : null,
    );
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> cancelBooking(String id) async {
    final res = await _dio.patch('${ApiConstants.bookings}/$id/cancel');
    return res.data['data'] as Map<String, dynamic>;
  }
}
