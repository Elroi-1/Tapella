import '../../../../core/domain/cache_result.dart';
import '../entities/listing_entity.dart';
import '../repositories/listings_repository.dart';

class GetAllListingsUseCase {
  final ListingsRepositoryContract repository;
  GetAllListingsUseCase(this.repository);

  Future<CacheResult<List<ListingEntity>>> call({String? search, String? category}) {
    return repository.getListings(search: search, category: category);
  }
}

class GetListingDetailsUseCase {
  final ListingsRepositoryContract repository;
  GetListingDetailsUseCase(this.repository);

  Future<CacheResult<ListingEntity>> call(String id) {
    return repository.getById(id);
  }
}

class GetMyListingsUseCase {
  final ListingsRepositoryContract repository;
  GetMyListingsUseCase(this.repository);

  Future<List<ListingEntity>> call() {
    return repository.getMyListings();
  }
}

class CreateListingUseCase {
  final ListingsRepositoryContract repository;
  CreateListingUseCase(this.repository);

  Future<ListingEntity> call(Map<String, dynamic> body) {
    return repository.create(body);
  }
}

class UpdateListingUseCase {
  final ListingsRepositoryContract repository;
  UpdateListingUseCase(this.repository);

  Future<ListingEntity> call(String id, Map<String, dynamic> body) {
    return repository.update(id, body);
  }
}

class DeleteListingUseCase {
  final ListingsRepositoryContract repository;
  DeleteListingUseCase(this.repository);

  Future<void> call(String id) {
    return repository.delete(id);
  }
}
