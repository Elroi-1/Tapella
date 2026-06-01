import '../entities/review_entity.dart';

abstract class ReviewsRepositoryContract {
  Future<List<ReviewEntity>> getByListing(String listingId);

  Future<ReviewEntity> submit({
    required String bookingId,
    required int rating,
    String? comment,
  });
}
