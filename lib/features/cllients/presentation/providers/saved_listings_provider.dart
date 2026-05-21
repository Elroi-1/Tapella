import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/database/app_database.dart';

part 'saved_listings_provider.g.dart';

@Riverpod(keepAlive: true)
class SavedListings extends _$SavedListings {
  static const _key = 'saved_listing_ids';

  @override
  Set<String> build() {
    _loadFromPrefs();
    return {};
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList(_key) ?? [];
      state = saved.toSet();
    } catch (_) {}

    // Fallback: Check if we have data in the old SQLite DB (mobile only)
    if (state.isEmpty && isLocalDatabaseSupported) {
      try {
        final db = await AppDatabase.instance();
        final rows = await db.query('saved_listings');
        final fromDb = rows.map((r) => r['listing_id'] as String).toSet();
        if (fromDb.isNotEmpty) {
          state = fromDb;
          await _saveToPrefs(fromDb);
        }
      } catch (_) {}
    }
  }

  Future<void> _saveToPrefs(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids.toList());
  }

  Future<void> toggleSave(String listingId) async {
    final newState = {...state};
    if (newState.contains(listingId)) {
      newState.remove(listingId);
    } else {
      newState.add(listingId);
    }
    state = newState;
    await _saveToPrefs(newState);

    // Sync with DB if supported (for offline backup on mobile)
    if (isLocalDatabaseSupported) {
      try {
        final db = await AppDatabase.instance();
        if (!state.contains(listingId)) {
          await db.delete(
            'saved_listings',
            where: 'listing_id = ?',
            whereArgs: [listingId],
          );
        } else {
          await db.insert('saved_listings', {'listing_id': listingId});
        }
      } catch (_) {}
    }
  }

  bool isSaved(String listingId) => state.contains(listingId);
}
