import 'package:tapella/core/domain/cache_result.dart';
import 'package:tapella/features/auth/domain/entities/user_entity.dart';
import 'package:tapella/features/auth/domain/repositories/auth_repository.dart';
import 'package:tapella/features/auth/domain/repositories/profile_repository.dart';
import 'package:tapella/features/bookings/domain/entities/booking_entity.dart';
import 'package:tapella/features/bookings/domain/repositories/bookings_repository.dart';
import 'package:tapella/features/reviews/domain/entities/review_entity.dart';
import 'package:tapella/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:tapella/features/services/domain/entities/listing_entity.dart';
import 'package:tapella/features/services/domain/repositories/listings_repository.dart';

class FakeAuthRepository implements AuthRepositoryContract {
  UserEntity? restoreSessionResult;
  UserEntity? loginResult;
  UserEntity? registerResult;
  Object? loginError;
  Object? registerError;
  bool logoutCalled = false;

  String? lastLoginEmail;
  String? lastLoginPassword;
  bool? lastLoginIsProvider;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
    required bool isProvider,
  }) async {
    lastLoginEmail = email;
    lastLoginPassword = password;
    lastLoginIsProvider = isProvider;
    if (loginError != null) throw loginError!;
    return loginResult ?? UserEntity(
      id: 'fallback',
      email: email,
      role: isProvider ? 'provider' : 'customer',
      displayName: 'Fallback User',
    );
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String displayName,
    required bool isProvider,
    String? phone,
    String? profession,
  }) async {
    if (registerError != null) throw registerError!;
    return registerResult ?? UserEntity(
      id: 'new-user',
      email: email,
      role: isProvider ? 'provider' : 'customer',
      displayName: displayName,
      phone: phone,
      profession: profession,
    );
  }

  @override
  Future<UserEntity?> restoreSession() async => restoreSessionResult;

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }
}

class FakeProfileRepository implements ProfileRepositoryContract {
  UserEntity? fetchProfileResult;
  UserEntity? updateProfileResult;
  Object? fetchProfileError;
  Object? updateProfileError;
  Object? deleteAccountError;
  bool deleteAccountCalled = false;

  String? lastUpdateDisplayName;
  String? lastUpdateEmail;

  @override
  Future<UserEntity> fetchProfile() async {
    if (fetchProfileError != null) throw fetchProfileError!;
    return fetchProfileResult ?? const UserEntity(
      id: 'user-1',
      email: 'customer@tapella.test',
      role: 'customer',
      displayName: 'Test Customer',
    );
  }

  @override
  Future<UserEntity> updateProfile({
    required String displayName,
    required String email,
    String? phone,
    String? location,
    String? bio,
    String? profileImage,
    String? profession,
  }) async {
    lastUpdateDisplayName = displayName;
    lastUpdateEmail = email;
    if (updateProfileError != null) throw updateProfileError!;
    return updateProfileResult ?? UserEntity(
      id: 'user-1',
      email: email,
      role: 'customer',
      displayName: displayName,
      phone: phone,
      location: location,
      bio: bio,
      profileImage: profileImage,
      profession: profession,
    );
  }

  @override
  Future<void> deleteAccount() async {
    deleteAccountCalled = true;
    if (deleteAccountError != null) throw deleteAccountError!;
  }
}

class FakeListingsRepository implements ListingsRepositoryContract {
  CacheResult<List<ListingEntity>>? listingsResult;
  CacheResult<ListingEntity>? listingByIdResult;
  List<ListingEntity>? myListingsResult;
  ListingEntity? createResult;
  ListingEntity? updateResult;
  Object? listingsError;
  Object? createError;
  String? lastDeletedId;
  String? lastSearch;
  String? lastCategory;

  @override
  Future<CacheResult<List<ListingEntity>>> getListings({
    String? search,
    String? category,
  }) async {
    lastSearch = search;
    lastCategory = category;
    if (listingsError != null) throw listingsError!;
    return listingsResult ?? const CacheResult(data: []);
  }

  @override
  Future<CacheResult<ListingEntity>> getById(String id) async {
    return listingByIdResult ??
        CacheResult(
          data: ListingEntity(
            id: id,
            providerId: 'user-2',
            providerName: 'Provider',
            title: 'Service',
            description: 'Description',
            category: 'Plumbing',
            priceEtb: 100,
            location: 'Addis Ababa',
            phone: '+251900000000',
            ratingAvg: 4,
            reviewCount: 1,
          ),
        );
  }

  @override
  Future<List<ListingEntity>> getMyListings() async {
    return myListingsResult ?? const [];
  }

  @override
  Future<ListingEntity> create(Map<String, dynamic> body) async {
    if (createError != null) throw createError!;
    return createResult ??
        ListingEntity(
          id: 'new-listing',
          providerId: 'user-2',
          providerName: 'Provider',
          title: body['title'] as String? ?? 'Untitled',
          description: body['description'] as String? ?? '',
          category: body['category'] as String? ?? 'General',
          priceEtb: (body['priceEtb'] as num?)?.toDouble() ?? 0,
          location: body['location'] as String? ?? '',
          phone: body['phone'] as String? ?? '',
          ratingAvg: 0,
          reviewCount: 0,
        );
  }

  @override
  Future<ListingEntity> update(String id, Map<String, dynamic> body) async {
    return updateResult ??
        ListingEntity(
          id: id,
          providerId: 'user-2',
          providerName: 'Provider',
          title: body['title'] as String? ?? 'Updated',
          description: body['description'] as String? ?? '',
          category: body['category'] as String? ?? 'General',
          priceEtb: (body['priceEtb'] as num?)?.toDouble() ?? 0,
          location: body['location'] as String? ?? '',
          phone: body['phone'] as String? ?? '',
          ratingAvg: 4,
          reviewCount: 1,
        );
  }

  @override
  Future<void> delete(String id) async {
    lastDeletedId = id;
  }
}

class FakeBookingsRepository implements BookingsRepositoryContract {
  BookingEntity? createResult;
  CacheResult<List<BookingEntity>>? customerBookingsResult;
  CacheResult<List<BookingEntity>>? incomingBookingsResult;
  CacheResult<List<BookingEntity>>? historyBookingsResult;
  BookingEntity? updateStatusResult;
  BookingEntity? completeResult;
  BookingEntity? cancelResult;
  Object? createError;

  String? lastCreatedListingId;
  String? lastUpdatedStatus;

  @override
  Future<BookingEntity> create({
    required String listingId,
    String? scheduledDate,
    String? notes,
  }) async {
    lastCreatedListingId = listingId;
    if (createError != null) throw createError!;
    return createResult ??
        BookingEntity(
          id: 'booking-new',
          listingId: listingId,
          listingTitle: 'Service',
          customerId: 'user-1',
          customerName: 'Customer',
          providerId: 'user-2',
          providerName: 'Provider',
          status: 'pending',
          scheduledDate: scheduledDate,
          notes: notes ?? '',
        );
  }

  @override
  Future<CacheResult<List<BookingEntity>>> customerBookings() async {
    return customerBookingsResult ?? const CacheResult(data: []);
  }

  @override
  Future<CacheResult<List<BookingEntity>>> incomingBookings() async {
    return incomingBookingsResult ?? const CacheResult(data: []);
  }

  @override
  Future<CacheResult<List<BookingEntity>>> historyBookings() async {
    return historyBookingsResult ?? const CacheResult(data: []);
  }

  @override
  Future<BookingEntity> updateStatus(String id, String status) async {
    lastUpdatedStatus = status;
    return updateStatusResult ??
        BookingEntity(
          id: id,
          listingId: 'listing-1',
          listingTitle: 'Service',
          customerId: 'user-1',
          customerName: 'Customer',
          providerId: 'user-2',
          providerName: 'Provider',
          status: status,
        );
  }

  @override
  Future<BookingEntity> complete(String id, {double? amount}) async {
    return completeResult ??
        BookingEntity(
          id: id,
          listingId: 'listing-1',
          listingTitle: 'Service',
          customerId: 'user-1',
          customerName: 'Customer',
          providerId: 'user-2',
          providerName: 'Provider',
          status: 'completed',
          amountEtb: amount ?? 0,
        );
  }

  @override
  Future<BookingEntity> cancel(String id) async {
    return cancelResult ??
        BookingEntity(
          id: id,
          listingId: 'listing-1',
          listingTitle: 'Service',
          customerId: 'user-1',
          customerName: 'Customer',
          providerId: 'user-2',
          providerName: 'Provider',
          status: 'cancelled',
        );
  }
}

class FakeReviewsRepository implements ReviewsRepositoryContract {
  List<ReviewEntity>? reviewsByListingResult;
  ReviewEntity? submitResult;
  Object? submitError;

  String? lastListingId;
  String? lastBookingId;
  int? lastRating;

  @override
  Future<List<ReviewEntity>> getByListing(String listingId) async {
    lastListingId = listingId;
    return reviewsByListingResult ?? const [];
  }

  @override
  Future<ReviewEntity> submit({
    required String bookingId,
    required int rating,
    String? comment,
  }) async {
    lastBookingId = bookingId;
    lastRating = rating;
    if (submitError != null) throw submitError!;
    return submitResult ??
        ReviewEntity(
          id: 'review-new',
          bookingId: bookingId,
          listingId: 'listing-1',
          customerId: 'user-1',
          customerName: 'Customer',
          rating: rating,
          comment: comment ?? '',
        );
  }
}
