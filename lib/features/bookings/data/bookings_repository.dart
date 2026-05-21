import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/cache/cache_invalidator.dart';
import '../../../core/connectivity/connectivity_service.dart';
import '../../../core/data/cache_result.dart';
import '../../../core/database/app_database.dart';
import '../../../core/exceptions/api_exception.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/dio_client.dart';

part 'bookings_repository.g.dart';

@riverpod
BookingsRepository bookingsRepository(Ref ref) {
  return BookingsRepository(
    ref.watch(dioProvider),
    ref.watch(cacheInvalidatorProvider),
    ref.watch(connectivityServiceProvider),
  );
}

class BookingsRepository {
  final Dio _dio;
  final CacheInvalidator _invalidator;
  final ConnectivityService _connectivity;

  BookingsRepository(this._dio, this._invalidator, this._connectivity);

  Future<BookingModel> create({
    required String listingId,
    String? scheduledDate,
    String? notes,
  }) async {
    try {
      final res = await _dio.post(
        ApiConstants.bookings,
        data: {
          'listingId': listingId,
          'scheduledDate': ?scheduledDate,
          'notes': ?notes,
        },
      );
      final booking = BookingModel.fromJson(
        res.data['data'] as Map<String, dynamic>,
      );
      if (isLocalDatabaseSupported) {
        await _invalidator.invalidateBookings();
      }
      return booking;
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    }
  }

  Future<CacheResult<List<BookingModel>>> customerBookings() async {
    return _fetchList('${ApiConstants.bookings}/mine');
  }

  Future<CacheResult<List<BookingModel>>> incomingBookings() async {
    return _fetchList('${ApiConstants.bookings}/incoming');
  }

  Future<CacheResult<List<BookingModel>>> historyBookings() async {
    return _fetchList('${ApiConstants.bookings}/history');
  }

  Future<CacheResult<List<BookingModel>>> _fetchList(String path) async {
    if (!isLocalDatabaseSupported) {
      try {
        final res = await _dio.get(path);
        return CacheResult(data: _parseList(res.data['data']));
      } on DioException catch (e) {
        throw ApiExceptionMapper.fromDio(e);
      }
    }
    return _cacheFirst(path);
  }

  Future<CacheResult<List<BookingModel>>> _cacheFirst(String path) async {
    final db = await AppDatabase.instance();
    final cached = await db.query('bookings');
    if (cached.isNotEmpty && !await _connectivity.isOnline) {
      return CacheResult(
        data: cached.map((r) => BookingModel.fromDb(r)).toList(),
        isStale: true,
      );
    }
    try {
      final res = await _dio.get(path);
      final list = _parseList(res.data['data']);
      await _saveAll(list);
      return CacheResult(data: list);
    } on DioException catch (e) {
      return _offlineFallback(e);
    }
  }

  Future<CacheResult<List<BookingModel>>> _offlineFallback(
    DioException e,
  ) async {
    if (!isLocalDatabaseSupported) {
      throw ApiExceptionMapper.fromDio(e);
    }
    final db = await AppDatabase.instance();
    final cached = await db.query('bookings');
    if (cached.isNotEmpty) {
      return CacheResult(
        data: cached.map((r) => BookingModel.fromDb(r)).toList(),
        isStale: true,
      );
    }
    throw ApiExceptionMapper.fromDio(e);
  }

  List<BookingModel> _parseList(dynamic data) {
    return (data as List)
        .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveAll(List<BookingModel> list) async {
    if (!isLocalDatabaseSupported) return;
    final db = await AppDatabase.instance();
    for (final b in list) {
      await db.insert(
        'bookings',
        b.toDbMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<BookingModel> updateStatus(String id, String status) async {
    try {
      final res = await _dio.patch(
        '${ApiConstants.bookings}/$id/status',
        data: {'status': status},
      );
      final booking = BookingModel.fromJson(
        res.data['data'] as Map<String, dynamic>,
      );
      if (isLocalDatabaseSupported) {
        await _invalidator.invalidateBookings();
      }
      return booking;
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    }
  }

  Future<BookingModel> complete(String id, {double? amount}) async {
    try {
      final res = await _dio.patch(
        '${ApiConstants.bookings}/$id/complete',
        data: amount != null ? {'amountEtb': amount} : null,
      );
      final booking = BookingModel.fromJson(
        res.data['data'] as Map<String, dynamic>,
      );
      if (isLocalDatabaseSupported) {
        await _invalidator.invalidateBookings();
      }
      return booking;
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    }
  }

  Future<BookingModel> cancel(String id) async {
    try {
      final res = await _dio.patch('${ApiConstants.bookings}/$id/cancel');
      final booking = BookingModel.fromJson(
        res.data['data'] as Map<String, dynamic>,
      );
      if (isLocalDatabaseSupported) {
        await _invalidator.invalidateBookings();
      }
      return booking;
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    }
  }
}
