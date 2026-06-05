import 'package:tapella/core/domain/cache_result.dart';
import 'package:tapella/features/auth/domain/entities/user_entity.dart';
import 'package:tapella/features/bookings/domain/entities/booking_entity.dart';
import 'package:tapella/features/reviews/domain/entities/review_entity.dart';
import 'package:tapella/features/services/domain/entities/listing_entity.dart';

class Fixtures {
  static const customer = UserEntity(
    id: 'user-1',
    email: 'customer@tapella.test',
    role: 'customer',
    displayName: 'Test Customer',
    phone: '+251900000001',
    location: 'Addis Ababa',
    bio: 'Looking for services',
  );

  static const provider = UserEntity(
    id: 'user-2',
    email: 'provider@tapella.test',
    role: 'provider',
    displayName: 'Test Provider',
    phone: '+251900000002',
    location: 'Addis Ababa',
    profession: 'Plumbing',
  );

  static const listing = ListingEntity(
    id: 'listing-1',
    providerId: 'user-2',
    providerName: 'Test Provider',
    title: 'Pipe Repair',
    description: 'Fast plumbing service',
    category: 'Plumbing',
    priceEtb: 500,
    location: 'Addis Ababa',
    phone: '+251900000002',
    ratingAvg: 4.5,
    reviewCount: 3,
  );

  static const booking = BookingEntity(
    id: 'booking-1',
    listingId: 'listing-1',
    listingTitle: 'Pipe Repair',
    customerId: 'user-1',
    customerName: 'Test Customer',
    providerId: 'user-2',
    providerName: 'Test Provider',
    status: 'pending',
    scheduledDate: '2026-06-10',
    notes: 'Urgent repair',
  );

  static const review = ReviewEntity(
    id: 'review-1',
    bookingId: 'booking-1',
    listingId: 'listing-1',
    customerId: 'user-1',
    customerName: 'Test Customer',
    rating: 5,
    comment: 'Great service',
  );

  static CacheResult<List<ListingEntity>> listingsResult({
    List<ListingEntity>? data,
    bool isStale = false,
  }) {
    return CacheResult(
      data: data ?? const [listing],
      isStale: isStale,
    );
  }

  static CacheResult<ListingEntity> listingDetailResult({
    ListingEntity? data,
    bool isStale = false,
  }) {
    return CacheResult(data: data ?? listing, isStale: isStale);
  }

  static CacheResult<List<BookingEntity>> bookingsResult({
    List<BookingEntity>? data,
    bool isStale = false,
  }) {
    return CacheResult(
      data: data ?? const [booking],
      isStale: isStale,
    );
  }
}
