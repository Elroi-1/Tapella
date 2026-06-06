import 'package:flutter_test/flutter_test.dart';
import 'package:tapella/features/reviews/domain/usecases/reviews_usecases.dart';

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/fixtures.dart';

void main() {
  late FakeReviewsRepository repository;

  setUp(() {
    repository = FakeReviewsRepository();
  });

  group('GetReviewsByListingUseCase', () {
    test('returns reviews for listing id', () async {
      repository.reviewsByListingResult = [Fixtures.review];
      final useCase = GetReviewsByListingUseCase(repository);

      final result = await useCase.call('listing-1');

      expect(result, [Fixtures.review]);
      expect(repository.lastListingId, 'listing-1');
    });
  });

  group('SubmitReviewUseCase', () {
    test('submits review through repository', () async {
      repository.submitResult = Fixtures.review;
      final useCase = SubmitReviewUseCase(repository);

      final result = await useCase.call(
        bookingId: 'booking-1',
        rating: 5,
        comment: 'Great service',
      );

      expect(result, Fixtures.review);
      expect(repository.lastBookingId, 'booking-1');
      expect(repository.lastRating, 5);
    });
  });
}
