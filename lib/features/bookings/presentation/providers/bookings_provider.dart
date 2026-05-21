import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/models/booking_model.dart';
import '../../data/bookings_repository.dart';
import '../../../services/presentation/providers/listings_provider.dart';

part 'bookings_provider.g.dart';

class ProviderStats {
  final int totalJobs;
  final int completedJobs;
  final double totalEarnings;
  final double averageRating;
  final List<BookingModel> pendingBookings;
  final List<BookingModel> completedBookings;

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
Future<List<BookingModel>> customerBookings(Ref ref) async {
  final result = await ref.read(bookingsRepositoryProvider).customerBookings();
  return result.data;
}

@riverpod
Future<bool> customerBookingsStale(Ref ref) async {
  final result = await ref.read(bookingsRepositoryProvider).customerBookings();
  return result.isStale;
}

@riverpod
Future<List<BookingModel>> incomingBookings(Ref ref) async {
  final result = await ref.read(bookingsRepositoryProvider).incomingBookings();
  return result.data;
}

@riverpod
Future<List<BookingModel>> historyBookings(Ref ref) async {
  final result = await ref.read(bookingsRepositoryProvider).historyBookings();
  return result.data;
}

@Riverpod(keepAlive: true)
BookingActions bookingActions(Ref ref) => BookingActions(ref);

class BookingActions {
  final Ref ref;
  BookingActions(this.ref);

  Future<void> accept(String id) async {
    await ref.read(bookingsRepositoryProvider).updateStatus(id, 'accepted');
    ref.invalidate(incomingBookingsProvider);
    ref.invalidate(historyBookingsProvider);
  }

  Future<void> reject(String id) async {
    await ref.read(bookingsRepositoryProvider).updateStatus(id, 'rejected');
    ref.invalidate(incomingBookingsProvider);
    ref.invalidate(historyBookingsProvider);
  }

  Future<void> complete(String id, {double? amount}) async {
    await ref.read(bookingsRepositoryProvider).complete(id, amount: amount);
    ref.invalidate(incomingBookingsProvider);
    ref.invalidate(historyBookingsProvider);
  }

  Future<void> cancel(String id) async {
    await ref.read(bookingsRepositoryProvider).cancel(id);
    ref.invalidate(customerBookingsProvider);
  }

  Future<BookingModel> book({
    required String listingId,
    String? scheduledDate,
    String? notes,
  }) async {
    final booking = await ref
        .read(bookingsRepositoryProvider)
        .create(
          listingId: listingId,
          scheduledDate: scheduledDate,
          notes: notes,
        );
    ref.invalidate(customerBookingsProvider);
    return booking;
  }
}
