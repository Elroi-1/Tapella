import 'package:flutter_test/flutter_test.dart';
import 'package:tapella/features/bookings/domain/usecases/bookings_usecases.dart';

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/fixtures.dart';

void main() {
  late FakeBookingsRepository repository;

  setUp(() {
    repository = FakeBookingsRepository();
  });

  group('CreateBookingUseCase', () {
    test('creates booking with listing and schedule', () async {
      repository.createResult = Fixtures.booking;
      final useCase = CreateBookingUseCase(repository);

      final result = await useCase.call(
        listingId: 'listing-1',
        scheduledDate: '2026-06-10',
        notes: 'Urgent repair',
      );

      expect(result, Fixtures.booking);
      expect(repository.lastCreatedListingId, 'listing-1');
    });
  });

  group('GetCustomerBookingsUseCase', () {
    test('returns customer bookings cache result', () async {
      repository.customerBookingsResult = Fixtures.bookingsResult();
      final useCase = GetCustomerBookingsUseCase(repository);

      final result = await useCase.call();

      expect(result.data, [Fixtures.booking]);
    });
  });

  group('GetIncomingBookingsUseCase', () {
    test('returns incoming bookings cache result', () async {
      repository.incomingBookingsResult = Fixtures.bookingsResult();
      final useCase = GetIncomingBookingsUseCase(repository);

      final result = await useCase.call();

      expect(result.data, [Fixtures.booking]);
    });
  });

  group('UpdateBookingStatusUseCase', () {
    test('updates booking status through repository', () async {
      repository.updateStatusResult = Fixtures.booking;
      final useCase = UpdateBookingStatusUseCase(repository);

      final result = await useCase.call('booking-1', 'accepted');

      expect(result, Fixtures.booking);
      expect(repository.lastUpdatedStatus, 'accepted');
    });
  });

  group('CompleteBookingUseCase', () {
    test('completes booking with optional amount', () async {
      repository.completeResult = Fixtures.booking;
      final useCase = CompleteBookingUseCase(repository);

      final result = await useCase.call('booking-1', amount: 750);

      expect(result, Fixtures.booking);
    });
  });

  group('CancelBookingUseCase', () {
    test('cancels booking through repository', () async {
      repository.cancelResult = Fixtures.booking;
      final useCase = CancelBookingUseCase(repository);

      final result = await useCase.call('booking-1');

      expect(result, Fixtures.booking);
    });
  });
}
