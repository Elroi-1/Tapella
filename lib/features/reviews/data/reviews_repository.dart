import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/cache/cache_invalidator.dart';
import '../../../core/database/app_database.dart';
import '../../../core/exceptions/api_exception.dart';
import '../../../core/models/review_model.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/dio_client.dart';

part 'reviews_repository.g.dart';

@riverpod
ReviewsRepository reviewsRepository(Ref ref) {
  return ReviewsRepository(
    ref.watch(dioProvider),
    ref.watch(cacheInvalidatorProvider),
  );
}

class ReviewsRepository {
  final Dio _dio;
  final CacheInvalidator _invalidator;

  ReviewsRepository(this._dio, this._invalidator);

  Future<List<ReviewModel>> getByListing(String listingId) async {
    if (!isLocalDatabaseSupported) {
      try {
        final res = await _dio.get(
          '${ApiConstants.reviews}/listings/$listingId',
        );
        return (res.data['data'] as List)
            .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } on DioException catch (e) {
        throw ApiExceptionMapper.fromDio(e);
      }
    }

    final db = await AppDatabase.instance();
    final cached = await db.query(
      'reviews',
      where: 'listing_id = ?',
      whereArgs: [listingId],
    );
    try {
      final res = await _dio.get('${ApiConstants.reviews}/listings/$listingId');
      final list = (res.data['data'] as List)
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList();
      await db.delete(
        'reviews',
        where: 'listing_id = ?',
        whereArgs: [listingId],
      );
      for (final r in list) {
        await db.insert(
          'reviews',
          r.toDbMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      return list;
    } on DioException catch (e) {
      if (cached.isNotEmpty) {
        return cached.map((r) => ReviewModel.fromDb(r)).toList();
      }
      throw ApiExceptionMapper.fromDio(e);
    }
  }

  Future<ReviewModel> submit({
    required String bookingId,
    required int rating,
    String? comment,
  }) async {
    try {
      final res = await _dio.post(
        '${ApiConstants.reviews}/bookings/$bookingId',
        data: {'rating': rating, 'comment': ?comment},
      );
      final review = ReviewModel.fromJson(
        res.data['data'] as Map<String, dynamic>,
      );
      if (isLocalDatabaseSupported) {
        await _invalidator.invalidateListing(review.listingId);
        await _invalidator.invalidateReviewsForListing(review.listingId);
      }
      return review;
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    }
  }
}
