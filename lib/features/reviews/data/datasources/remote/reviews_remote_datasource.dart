import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';

class ReviewsRemoteDataSource {
  final Dio _dio;

  ReviewsRemoteDataSource(this._dio);

  Future<List<dynamic>> fetchReviewsByListing(String listingId) async {
    final res = await _dio.get('${ApiConstants.reviews}/listings/$listingId');
    return res.data['data'] as List;
  }

  Future<Map<String, dynamic>> submitReview({
    required String bookingId,
    required int rating,
    String? comment,
  }) async {
    final res = await _dio.post(
      '${ApiConstants.reviews}/bookings/$bookingId',
      data: {'rating': rating, 'comment': ?comment},
    );
    return res.data['data'] as Map<String, dynamic>;
  }
}
