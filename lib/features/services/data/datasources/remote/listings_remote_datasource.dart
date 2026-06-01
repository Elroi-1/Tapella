import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';

class ListingsRemoteDataSource {
  final Dio _dio;

  ListingsRemoteDataSource(this._dio);

  Future<List<dynamic>> fetchListings({
    String? search,
    String? category,
  }) async {
    final res = await _dio.get(
      ApiConstants.listings,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (category != null && category.isNotEmpty) 'category': category,
      },
    );
    return res.data['data'] as List;
  }

  Future<Map<String, dynamic>> fetchListingById(String id) async {
    final res = await _dio.get('${ApiConstants.listings}/$id');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<List<dynamic>> fetchMyListings() async {
    final res = await _dio.get('${ApiConstants.listings}/mine');
    return res.data['data'] as List;
  }

  Future<Map<String, dynamic>> createListing(Map<String, dynamic> body) async {
    final res = await _dio.post(ApiConstants.listings, data: body);
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<void> deleteListing(String id) async {
    await _dio.delete('${ApiConstants.listings}/$id');
  }

  Future<Map<String, dynamic>> updateListing(
    String id,
    Map<String, dynamic> body,
  ) async {
    final res = await _dio.patch('${ApiConstants.listings}/$id', data: body);
    return res.data['data'] as Map<String, dynamic>;
  }
}
