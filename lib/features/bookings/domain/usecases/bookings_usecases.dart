import '../../../../core/domain/cache_result.dart';
import '../entities/booking_entity.dart';
import '../repositories/bookings_repository.dart';

class CreateBookingUseCase {
  final BookingsRepositoryContract repository;
  CreateBookingUseCase(this.repository);

  Future<BookingEntity> call({
    required String listingId,
    String? scheduledDate,
    String? notes,
  }) {
    return repository.create(
      listingId: listingId,
      scheduledDate: scheduledDate,
      notes: notes,
    );
  }
}

class GetCustomerBookingsUseCase {
  final BookingsRepositoryContract repository;
  GetCustomerBookingsUseCase(this.repository);

  Future<CacheResult<List<BookingEntity>>> call() {
    return repository.customerBookings();
  }
}

class GetIncomingBookingsUseCase {
  final BookingsRepositoryContract repository;
  GetIncomingBookingsUseCase(this.repository);

  Future<CacheResult<List<BookingEntity>>> call() {
    return repository.incomingBookings();
  }
}

class GetHistoryBookingsUseCase {
  final BookingsRepositoryContract repository;
  GetHistoryBookingsUseCase(this.repository);

  Future<CacheResult<List<BookingEntity>>> call() {
    return repository.historyBookings();
  }
}

class UpdateBookingStatusUseCase {
  final BookingsRepositoryContract repository;
  UpdateBookingStatusUseCase(this.repository);

  Future<BookingEntity> call(String id, String status) {
    return repository.updateStatus(id, status);
  }
}

class CompleteBookingUseCase {
  final BookingsRepositoryContract repository;
  CompleteBookingUseCase(this.repository);

  Future<BookingEntity> call(String id, {double? amount}) {
    return repository.complete(id, amount: amount);
  }
}

class CancelBookingUseCase {
  final BookingsRepositoryContract repository;
  CancelBookingUseCase(this.repository);

  Future<BookingEntity> call(String id) {
    return repository.cancel(id);
  }
}
