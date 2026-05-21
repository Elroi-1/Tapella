import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/models/review_model.dart';
import '../../data/reviews_repository.dart';

part 'reviews_provider.g.dart';

@riverpod
Future<List<ReviewModel>> listingReviews(Ref ref, String listingId) {
  return ref.read(reviewsRepositoryProvider).getByListing(listingId);
}

@Riverpod(keepAlive: true)
SubmitReviewActions submitReview(Ref ref) => SubmitReviewActions(ref);

class SubmitReviewActions {
  final Ref ref;
  SubmitReviewActions(this.ref);

  Future<void> submit({
    required String bookingId,
    required int rating,
    String? comment,
  }) async {
    await ref
        .read(reviewsRepositoryProvider)
        .submit(bookingId: bookingId, rating: rating, comment: comment);
  }
}
