import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';

part 'cache_invalidator.g.dart';

class CacheInvalidator {
  Future<Database> get _db => AppDatabase.instance();

  Future<void> invalidateListings() async {
    if (kIsWeb) return;
    final db = await _db;
    await db.delete('listings');
  }

  Future<void> invalidateListing(String id) async {
    if (kIsWeb) return;
    final db = await _db;
    await db.delete('listings', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> invalidateBookings() async {
    if (kIsWeb) return;
    final db = await _db;
    await db.delete('bookings');
  }

  Future<void> invalidateReviewsForListing(String listingId) async {
    if (kIsWeb) return;
    final db = await _db;
    await db.delete('reviews', where: 'listing_id = ?', whereArgs: [listingId]);
  }

  Future<void> onListingDeleted(String id) async {
    await invalidateListing(id);
    await invalidateReviewsForListing(id);
  }

  Future<void> invalidateAll() async {
    if (kIsWeb) return;
    final db = await _db;
    await db.delete('listings');
    await db.delete('bookings');
    await db.delete('reviews');
  }
}

@riverpod
CacheInvalidator cacheInvalidator(Ref ref) => CacheInvalidator();
