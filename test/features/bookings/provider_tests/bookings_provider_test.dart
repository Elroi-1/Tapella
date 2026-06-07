import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tapella/features/bookings/presentation/providers/bookings_provider.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/fixtures.dart';
import '../../../helpers/riverpod_test_helpers.dart';

void main() {
  late FakeBookingsRepository bookingsRepository;
  late ProviderContainer container;

  setUp(() {
    bookingsRepository = FakeBookingsRepository();
    container = createBookingsTestContainer(
      bookingsRepository: bookingsRepository,
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('Booking providers', () {
    test('customerBookings returns bookings from use case', () async {
      bookingsRepository.customerBookingsResult = Fixtures.bookingsResult();

      final bookings = await container.read(customerBookingsProvider.future);

      expect(bookings, [Fixtures.booking]);
    });

    test('incomingBookings returns bookings from use case', () async {
      bookingsRepository.incomingBookingsResult = Fixtures.bookingsResult();

      final bookings = await container.read(incomingBookingsProvider.future);

      expect(bookings, [Fixtures.booking]);
    });
  });

  group('BookingActions', () {
    test('book creates booking through use case', () async {
      bookingsRepository.createResult = Fixtures.booking;

      final booking = await container
          .read(bookingActionsProvider)
          .book(
            listingId: 'listing-1',
            scheduledDate: '2026-06-10',
            notes: 'Please call first',
          );

      expect(booking, Fixtures.booking);
      expect(bookingsRepository.lastCreatedListingId, 'listing-1');
    });

    test('accept updates booking status to accepted', () async {
      bookingsRepository.updateStatusResult = Fixtures.booking;

      await container.read(bookingActionsProvider).accept('booking-1');

      expect(bookingsRepository.lastUpdatedStatus, 'accepted');
    });

    test('reject updates booking status to rejected', () async {
      bookingsRepository.updateStatusResult = Fixtures.booking;

      await container.read(bookingActionsProvider).reject('booking-1');

      expect(bookingsRepository.lastUpdatedStatus, 'rejected');
    });
  });
}
