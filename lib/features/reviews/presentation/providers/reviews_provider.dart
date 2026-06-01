import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/usecases/reviews_usecases.dart';
import '../../data/reviews_repository.dart';

part 'reviews_provider.g.dart';

@riverpod
GetReviewsByListingUseCase getReviewsByListingUseCase(Ref ref) {
  return GetReviewsByListingUseCase(ref.watch(reviewsRepositoryProvider));
}

@riverpod
SubmitReviewUseCase submitReviewUseCase(Ref ref) {
  return SubmitReviewUseCase(ref.watch(reviewsRepositoryProvider));
}

@riverpod
Future<List<ReviewEntity>> listingReviews(Ref ref, String listingId) {
  return ref.read(getReviewsByListingUseCaseProvider).call(listingId);
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
        .read(submitReviewUseCaseProvider)
        .call(bookingId: bookingId, rating: rating, comment: comment);
  }
}
