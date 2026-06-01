import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/bookings_usecases.dart';
import '../../data/bookings_repository.dart';
import '../../../services/presentation/providers/listings_provider.dart';

part 'bookings_provider.g.dart';

@riverpod
CreateBookingUseCase createBookingUseCase(Ref ref) {
  return CreateBookingUseCase(ref.watch(bookingsRepositoryProvider));
}

@riverpod
GetCustomerBookingsUseCase getCustomerBookingsUseCase(Ref ref) {
  return GetCustomerBookingsUseCase(ref.watch(bookingsRepositoryProvider));
}

@riverpod
GetIncomingBookingsUseCase getIncomingBookingsUseCase(Ref ref) {
  return GetIncomingBookingsUseCase(ref.watch(bookingsRepositoryProvider));
}

@riverpod
GetHistoryBookingsUseCase getHistoryBookingsUseCase(Ref ref) {
  return GetHistoryBookingsUseCase(ref.watch(bookingsRepositoryProvider));
}

@riverpod
UpdateBookingStatusUseCase updateBookingStatusUseCase(Ref ref) {
  return UpdateBookingStatusUseCase(ref.watch(bookingsRepositoryProvider));
}

@riverpod
CompleteBookingUseCase completeBookingUseCase(Ref ref) {
  return CompleteBookingUseCase(ref.watch(bookingsRepositoryProvider));
}

@riverpod
CancelBookingUseCase cancelBookingUseCase(Ref ref) {
  return CancelBookingUseCase(ref.watch(bookingsRepositoryProvider));
}

class ProviderStats {
  final int totalJobs;
  final int completedJobs;
  final double totalEarnings;
  final double averageRating;
  final List<BookingEntity> pendingBookings;
  final List<BookingEntity> completedBookings;

  const ProviderStats({
    required this.totalJobs,
    required this.completedJobs,
    required this.totalEarnings,
    required this.averageRating,
    required this.pendingBookings,
    required this.completedBookings,
  });
}

@riverpod
Future<ProviderStats> providerStats(Ref ref) async {
  final incoming = await ref.watch(incomingBookingsProvider.future);
  final history = await ref.watch(historyBookingsProvider.future);
  final listings = await ref.watch(myListingsProvider.future);

  final allBookings = [...incoming, ...history];
  final pendingBookings = allBookings
      .where((b) => b.status == 'accepted' || b.status == 'pending')
      .toList();
  final completedBookings = allBookings
      .where((b) => b.status == 'completed')
      .toList();

  final totalJobs = allBookings.length;
  final completedJobs = completedBookings.length;
  final totalEarnings = completedBookings.fold<double>(
    0,
    (sum, b) => sum + b.amountEtb,
  );

  double averageRating = 0;
  if (listings.isNotEmpty) {
    double totalWeightedRating = 0;
    int totalReviews = 0;
    for (final listing in listings) {
      totalWeightedRating += listing.ratingAvg * listing.reviewCount;
      totalReviews += listing.reviewCount;
    }
    if (totalReviews > 0) {
      averageRating = totalWeightedRating / totalReviews;
    }
  }

  return ProviderStats(
    totalJobs: totalJobs,
    completedJobs: completedJobs,
    totalEarnings: totalEarnings,
    averageRating: averageRating,
    pendingBookings: pendingBookings,
    completedBookings: completedBookings,
  );
}

@riverpod
Future<List<BookingEntity>> customerBookings(Ref ref) async {
  final result = await ref.read(getCustomerBookingsUseCaseProvider).call();
  return result.data;
}

@riverpod
Future<bool> customerBookingsStale(Ref ref) async {
  final result = await ref.read(getCustomerBookingsUseCaseProvider).call();
  return result.isStale;
}

@riverpod
Future<List<BookingEntity>> incomingBookings(Ref ref) async {
  final result = await ref.read(getIncomingBookingsUseCaseProvider).call();
  return result.data;
}

@riverpod
Future<List<BookingEntity>> historyBookings(Ref ref) async {
  final result = await ref.read(getHistoryBookingsUseCaseProvider).call();
  return result.data;
}

@Riverpod(keepAlive: true)
BookingActions bookingActions(Ref ref) => BookingActions(ref);

class BookingActions {
  final Ref ref;
  BookingActions(this.ref);

  Future<void> accept(String id) async {
    await ref.read(updateBookingStatusUseCaseProvider).call(id, 'accepted');
    ref.invalidate(incomingBookingsProvider);
    ref.invalidate(historyBookingsProvider);
  }

  Future<void> reject(String id) async {
    await ref.read(updateBookingStatusUseCaseProvider).call(id, 'rejected');
    ref.invalidate(incomingBookingsProvider);
    ref.invalidate(historyBookingsProvider);
  }

  Future<void> complete(String id, {double? amount}) async {
    await ref.read(completeBookingUseCaseProvider).call(id, amount: amount);
    ref.invalidate(incomingBookingsProvider);
    ref.invalidate(historyBookingsProvider);
  }

  Future<void> cancel(String id) async {
    await ref.read(cancelBookingUseCaseProvider).call(id);
    ref.invalidate(customerBookingsProvider);
  }

  Future<BookingEntity> book({
    required String listingId,
    String? scheduledDate,
    String? notes,
  }) async {
    final booking = await ref
        .read(createBookingUseCaseProvider)
        .call(
          listingId: listingId,
          scheduledDate: scheduledDate,
          notes: notes,
        );
    ref.invalidate(customerBookingsProvider);
    return booking;
  }
}
