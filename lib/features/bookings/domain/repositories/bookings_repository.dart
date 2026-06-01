import '../../../../core/domain/cache_result.dart';
import '../entities/booking_entity.dart';

abstract class BookingsRepositoryContract {
  Future<BookingEntity> create({
    required String listingId,
    String? scheduledDate,
    String? notes,
  });

  Future<CacheResult<List<BookingEntity>>> customerBookings();

  Future<CacheResult<List<BookingEntity>>> incomingBookings();

  Future<CacheResult<List<BookingEntity>>> historyBookings();

  Future<BookingEntity> updateStatus(String id, String status);

  Future<BookingEntity> complete(String id, {double? amount});

  Future<BookingEntity> cancel(String id);
}
