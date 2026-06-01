import '../../../../core/domain/cache_result.dart';
import '../entities/listing_entity.dart';

abstract class ListingsRepositoryContract {
  Future<CacheResult<List<ListingEntity>>> getListings({
    String? search,
    String? category,
  });

  Future<CacheResult<ListingEntity>> getById(String id);

  Future<List<ListingEntity>> getMyListings();

  Future<ListingEntity> create(Map<String, dynamic> body);

  Future<ListingEntity> update(String id, Map<String, dynamic> body);

  Future<void> delete(String id);
}
