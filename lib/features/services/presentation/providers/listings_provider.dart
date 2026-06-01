import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/domain/cache_result.dart';
import '../../domain/entities/listing_entity.dart';
import '../../domain/usecases/listings_usecases.dart';
import '../../data/listings_repository.dart';

part 'listings_provider.g.dart';

@riverpod
GetAllListingsUseCase getAllListingsUseCase(Ref ref) {
  return GetAllListingsUseCase(ref.watch(listingsRepositoryProvider));
}

@riverpod
GetListingDetailsUseCase getListingDetailsUseCase(Ref ref) {
  return GetListingDetailsUseCase(ref.watch(listingsRepositoryProvider));
}

@riverpod
GetMyListingsUseCase getMyListingsUseCase(Ref ref) {
  return GetMyListingsUseCase(ref.watch(listingsRepositoryProvider));
}

@riverpod
CreateListingUseCase createListingUseCase(Ref ref) {
  return CreateListingUseCase(ref.watch(listingsRepositoryProvider));
}

@riverpod
UpdateListingUseCase updateListingUseCase(Ref ref) {
  return UpdateListingUseCase(ref.watch(listingsRepositoryProvider));
}

@riverpod
DeleteListingUseCase deleteListingUseCase(Ref ref) {
  return DeleteListingUseCase(ref.watch(listingsRepositoryProvider));
}

class ListingsState {
  final List<ListingEntity> listings;
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
          .read(getAllListingsUseCaseProvider)
          .call(search: search, category: category);
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
Future<CacheResult<ListingEntity>> listingDetail(Ref ref, String id) {
  return ref.read(getListingDetailsUseCaseProvider).call(id);
}

@riverpod
Future<List<ListingEntity>> myListings(Ref ref) {
  return ref.read(getMyListingsUseCaseProvider).call();
}

@Riverpod(keepAlive: true)
class CreateListing extends _$CreateListing {
  @override
  void build() {
    // Keep reference to use cases
    ref.watch(createListingUseCaseProvider);
    ref.watch(updateListingUseCaseProvider);
  }

  Future<ListingEntity> createListing(Map<String, dynamic> body) async {
    state = const AsyncLoading();
    try {
      final item = await ref.read(createListingUseCaseProvider).call(body);

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

  Future<ListingEntity> updateListing(
    String id,
    Map<String, dynamic> body,
  ) async {
    state = const AsyncLoading();
    try {
      final item = await ref.read(updateListingUseCaseProvider).call(id, body);

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

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    try {
      await ref.read(deleteListingUseCaseProvider).call(id);

      if (!ref.mounted) return;

      ref.invalidate(listingsProvider);
      state = const AsyncData(null);
    } catch (e, st) {
      if (ref.mounted) {
        state = AsyncError(e, st);
      }
      rethrow;
    }
  }
}
