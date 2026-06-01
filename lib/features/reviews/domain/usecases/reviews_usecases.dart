import '../entities/review_entity.dart';
import '../repositories/reviews_repository.dart';

class GetReviewsByListingUseCase {
  final ReviewsRepositoryContract repository;
  GetReviewsByListingUseCase(this.repository);

  Future<List<ReviewEntity>> call(String listingId) {
    return repository.getByListing(listingId);
  }
}

class SubmitReviewUseCase {
  final ReviewsRepositoryContract repository;
  SubmitReviewUseCase(this.repository);

  Future<ReviewEntity> call({
    required String bookingId,
    required int rating,
    String? comment,
  }) {
    return repository.submit(
      bookingId: bookingId,
      rating: rating,
      comment: comment,
    );
  }
}
