import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/data/cache_result.dart';
import '../../../../core/models/listing_model.dart';
import '../../data/listings_repository.dart';

part 'listings_provider.g.dart';

class ListingsState {
  final List<ListingModel> listings;
  final bool isLoading;
  final bool isStale;
  final String? error;
  final String? selectedCategory;

  const ListingsState({
    this.listings = const [],
    this.isLoading = false,
    this.isStale = false,
    this.error,
    this.selectedCategory,
  });
}

@riverpod
class Listings extends _$Listings {
  @override
  ListingsState build() {
    load();
    return const ListingsState(isLoading: true);
  }

  Future<void> load({String? search, String? category}) async {
    state = ListingsState(isLoading: true, selectedCategory: category);
    try {
      final result = await ref
          .read(listingsRepositoryProvider)
          .getListings(search: search, category: category);
      state = ListingsState(
        listings: result.data,
        isStale: result.isStale,
        selectedCategory: category,
      );
    } catch (e) {
      state = ListingsState(error: e.toString(), selectedCategory: category);
    }
  }
}

@riverpod
Future<CacheResult<ListingModel>> listingDetail(Ref ref, String id) {
  return ref.read(listingsRepositoryProvider).getById(id);
}

@riverpod
Future<List<ListingModel>> myListings(Ref ref) {
  return ref.read(listingsRepositoryProvider).getMyListings();
}

@Riverpod(keepAlive: true)
class CreateListing extends _$CreateListing {
  @override
  void build() {
    // Keep a reference to the repository
    ref.watch(listingsRepositoryProvider);
  }

  Future<ListingModel> createListing(Map<String, dynamic> body) async {
    state = const AsyncLoading();
    try {
      final item = await ref.read(listingsRepositoryProvider).create(body);

      if (!ref.mounted) return item;

      ref.invalidate(listingsProvider);
      state = const AsyncData(null);
      return item;
    } catch (e, st) {
      if (ref.mounted) {
        state = AsyncError(e, st);
      }
      rethrow;
    }
  }

  Future<ListingModel> updateListing(
    String id,
    Map<String, dynamic> body,
  ) async {
    state = const AsyncLoading();
    try {
      final item = await ref.read(listingsRepositoryProvider).update(id, body);

      if (!ref.mounted) return item;

      ref.invalidate(listingsProvider);
      ref.invalidate(listingDetailProvider(id));
      state = const AsyncData(null);
      return item;
    } catch (e, st) {
      if (ref.mounted) {
        state = AsyncError(e, st);
      }
      rethrow;
    }
  }
}
