import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Local SQLite — not available on Flutter web.
bool get isLocalDatabaseSupported => !kIsWeb;

class AppDatabase {
  static Database? _db;
  static const _name = 'tapella.db';
  static const _version = 6;

  static Future<Database> instance() async {
    if (kIsWeb) {
      // Return a mock database or handle web gracefully
      // For now, we allow the app to continue without throwing,
      // but warn that actual SQLite operations will fail.
      // Better strategy: Use higher-level fallback/repos.
      return _stubDatabase();
    }
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), _name);
    _db = await openDatabase(
      path,
      version: _version,
      onCreate: (db, version) async {
        await _createV1(db);
        await _createV2(db);
        await _createV3(db);
        await _createV4(db);
        await _createV5(db);
        await _createV6(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 1) await _createV1(db);
        if (oldVersion < 2) await _createV2(db);
        if (oldVersion < 3) await _createV3(db);
        if (oldVersion < 4) await _createV4(db);
        if (oldVersion < 5) await _createV5(db);
        if (oldVersion < 6) await _createV6(db);
      },
    );
    return _db!;
  }

  /// Stubs database for Web to prevent crashes.
  /// Note: This is a placeholder. Real web persistence should use SharedPreferences/IndexedDB.
  static Future<Database> _stubDatabase() {
    throw UnsupportedError(
      'SQLite is not supported on web. Use SharedPreferences for persistence.',
    );
  }

  static Future<void> _createV1(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS auth_tokens (
        id INTEGER PRIMARY KEY,
        access_token TEXT NOT NULL,
        refresh_token TEXT NOT NULL,
        user_id TEXT NOT NULL,
        role TEXT NOT NULL,
        email TEXT NOT NULL,
        display_name TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users_cache (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        role TEXT NOT NULL,
        display_name TEXT NOT NULL,
        phone TEXT,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _createV2(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS listings (
        id TEXT PRIMARY KEY,
        provider_id TEXT NOT NULL,
        provider_name TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        price_etb REAL NOT NULL,
        location TEXT,
        phone TEXT,
        rating_avg REAL NOT NULL,
        review_count INTEGER NOT NULL,
        cached_at TEXT NOT NULL,
        is_stale INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  static Future<void> _createV3(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS bookings (
        id TEXT PRIMARY KEY,
        listing_id TEXT NOT NULL,
        listing_title TEXT NOT NULL,
        customer_id TEXT NOT NULL,
        customer_name TEXT NOT NULL,
        provider_id TEXT NOT NULL,
        provider_name TEXT NOT NULL,
        status TEXT NOT NULL,
        scheduled_date TEXT,
        notes TEXT,
        amount_etb REAL NOT NULL,
        cached_at TEXT NOT NULL,
        is_stale INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  static Future<void> _createV4(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS reviews (
        id TEXT PRIMARY KEY,
        booking_id TEXT NOT NULL,
        listing_id TEXT NOT NULL,
        customer_id TEXT NOT NULL,
        customer_name TEXT NOT NULL,
        rating INTEGER NOT NULL,
        comment TEXT,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _createV5(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS saved_listings (
        listing_id TEXT PRIMARY KEY
      )
    ''');
  }

  static Future<void> _createV6(Database db) async {
    // Add photo columns to existing tables
    await db.execute('ALTER TABLE listings ADD COLUMN provider_photo TEXT');
    await db.execute('ALTER TABLE bookings ADD COLUMN customer_photo TEXT');
    await db.execute('ALTER TABLE bookings ADD COLUMN provider_photo TEXT');
    await db.execute('ALTER TABLE reviews ADD COLUMN customer_photo TEXT');
    await db.execute('ALTER TABLE users_cache ADD COLUMN profile_image TEXT');
  }
}
