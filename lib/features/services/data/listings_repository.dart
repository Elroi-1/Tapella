import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/cache/cache_invalidator.dart';
import '../../../core/connectivity/connectivity_service.dart';
import '../../../core/domain/cache_result.dart';
import '../../../core/database/app_database.dart';
import '../../../core/exceptions/api_exception.dart';
import '../../../core/models/listing_model.dart';
import '../../../core/network/dio_client.dart';
import '../domain/repositories/listings_repository.dart';
import 'datasources/remote/listings_remote_datasource.dart';

part 'listings_repository.g.dart';

@riverpod
ListingsRepository listingsRepository(Ref ref) {
  return ListingsRepository(
    ListingsRemoteDataSource(ref.watch(dioProvider)),
    ref.watch(cacheInvalidatorProvider),
    ref.watch(connectivityServiceProvider),
  );
}

class ListingsRepository implements ListingsRepositoryContract {
  final ListingsRemoteDataSource _remote;
  final CacheInvalidator _invalidator;
  final ConnectivityService _connectivity;

  ListingsRepository(this._remote, this._invalidator, this._connectivity);

  @override
  Future<CacheResult<List<ListingModel>>> getListings({
    String? search,
    String? category,
  }) async {
    if (!isLocalDatabaseSupported) {
      return _fetchNetworkOnly(search: search, category: category);
    }
    final db = await AppDatabase.instance();
    final cached = await db.query('listings');
    if (cached.isNotEmpty) {
      final items = cached.map((r) => ListingModel.fromDb(r)).toList();
      final stale = cached.any((r) => (r['is_stale'] as int?) == 1);
      _refreshInBackground(search: search, category: category);
      return CacheResult(data: items, isStale: stale);
    }
    return _fetchAndCache(search: search, category: category);
  }

  Future<CacheResult<List<ListingModel>>> _fetchNetworkOnly({
    String? search,
    String? category,
  }) async {
    try {
      final data = await _remote.fetchListings(search: search, category: category);
      final list = data.map((e) => ListingModel.fromJson(e as Map<String, dynamic>)).toList();
      return CacheResult(data: list);
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    }
  }

  Future<void> _refreshInBackground({String? search, String? category}) async {
    if (!await _connectivity.isOnline) return;
    try {
      await _fetchAndCache(search: search, category: category);
    } catch (_) {}
  }

  Future<CacheResult<List<ListingModel>>> _fetchAndCache({
    String? search,
    String? category,
  }) async {
    try {
      final data = await _remote.fetchListings(search: search, category: category);
      final list = data.map((e) => ListingModel.fromJson(e as Map<String, dynamic>)).toList();
      await _saveListings(list);
      return CacheResult(data: list);
    } on DioException catch (e) {
      if (!isLocalDatabaseSupported) {
        throw ApiExceptionMapper.fromDio(e);
      }
      final db = await AppDatabase.instance();
      final cached = await db.query('listings');
      if (cached.isNotEmpty) {
        await db.update('listings', {'is_stale': 1});
        final items = cached.map((r) => ListingModel.fromDb(r)).toList();
        return CacheResult(data: items, isStale: true);
      }
      throw ApiExceptionMapper.fromDio(e);
    }
  }

  @override
  Future<CacheResult<ListingModel>> getById(String id) async {
    if (!isLocalDatabaseSupported) {
      return _fetchOne(id);
    }
    final db = await AppDatabase.instance();
    final rows = await db.query('listings', where: 'id = ?', whereArgs: [id]);
    if (rows.isNotEmpty) {
      final item = ListingModel.fromDb(rows.first);
      _fetchOneInBackground(id);
      return CacheResult(
        data: item,
        isStale: (rows.first['is_stale'] as int?) == 1,
      );
    }
    return _fetchOne(id);
  }

  Future<void> _fetchOneInBackground(String id) async {
    if (!await _connectivity.isOnline) return;
    try {
      await _fetchOne(id);
    } catch (_) {}
  }

  Future<CacheResult<ListingModel>> _fetchOne(String id) async {
    try {
      final data = await _remote.fetchListingById(id);
      final item = ListingModel.fromJson(data);
      if (isLocalDatabaseSupported) {
        final db = await AppDatabase.instance();
        await db.insert(
          'listings',
          item.toDbMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      return CacheResult(data: item);
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    }
  }

  @override
  Future<List<ListingModel>> getMyListings() async {
    try {
      final data = await _remote.fetchMyListings();
      final list = data.map((e) => ListingModel.fromJson(e as Map<String, dynamic>)).toList();
      await _saveListings(list);
      return list;
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    }
  }

  @override
  Future<ListingModel> create(Map<String, dynamic> body) async {
    try {
      final data = await _remote.createListing(body);
      final item = ListingModel.fromJson(data);
      if (isLocalDatabaseSupported) {
        final db = await AppDatabase.instance();
        await db.insert(
          'listings',
          item.toDbMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        await _invalidator.invalidateListings();
      }
      return item;
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    }
  }

  @override
  Future<void> delete(String id) async {
    await _remote.deleteListing(id);
    if (isLocalDatabaseSupported) {
      await _invalidator.onListingDeleted(id);
    }
  }

  @override
  Future<ListingModel> update(String id, Map<String, dynamic> body) async {
    try {
      final data = await _remote.updateListing(id, body);
      final item = ListingModel.fromJson(data);
      if (isLocalDatabaseSupported) {
        final db = await AppDatabase.instance();
        await db.insert(
          'listings',
          item.toDbMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        await _invalidator.invalidateListings();
      }
      return item;
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    }
  }

  Future<void> _saveListings(List<ListingModel> list) async {
    if (!isLocalDatabaseSupported) return;
    final db = await AppDatabase.instance();
    await db.delete('listings');
    for (final item in list) {
      await db.insert(
        'listings',
        item.toDbMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
