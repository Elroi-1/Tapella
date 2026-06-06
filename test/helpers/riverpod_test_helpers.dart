import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tapella/features/auth/domain/usecases/auth_usecases.dart';
import 'package:tapella/features/auth/presentation/providers/auth_provider.dart';
import 'package:tapella/features/bookings/domain/usecases/bookings_usecases.dart';
import 'package:tapella/features/bookings/presentation/providers/bookings_provider.dart';
import 'package:tapella/features/services/domain/usecases/listings_usecases.dart';
import 'package:tapella/features/services/presentation/providers/listings_provider.dart';

import 'fake_repositories.dart';

ProviderContainer createAuthTestContainer({
  FakeAuthRepository? authRepository,
  FakeProfileRepository? profileRepository,
}) {
  final authRepo = authRepository ?? FakeAuthRepository();
  final profileRepo = profileRepository ?? FakeProfileRepository();

  return ProviderContainer(
    overrides: [
      restoreSessionUseCaseProvider.overrideWithValue(
        RestoreSessionUseCase(authRepo),
      ),
      loginUseCaseProvider.overrideWithValue(LoginUseCase(authRepo)),
      registerUseCaseProvider.overrideWithValue(RegisterUseCase(authRepo)),
      logoutUseCaseProvider.overrideWithValue(LogoutUseCase(authRepo)),
      fetchProfileUseCaseProvider.overrideWithValue(
        FetchProfileUseCase(profileRepo),
      ),
      updateProfileUseCaseProvider.overrideWithValue(
        UpdateProfileUseCase(profileRepo),
      ),
      deleteAccountUseCaseProvider.overrideWithValue(
        DeleteAccountUseCase(profileRepo),
      ),
    ],
  );
}

ProviderContainer createListingsTestContainer({
  FakeListingsRepository? listingsRepository,
}) {
  final repo = listingsRepository ?? FakeListingsRepository();

  return ProviderContainer(
    overrides: [
      getAllListingsUseCaseProvider.overrideWithValue(GetAllListingsUseCase(repo)),
      getListingDetailsUseCaseProvider.overrideWithValue(
        GetListingDetailsUseCase(repo),
      ),
      getMyListingsUseCaseProvider.overrideWithValue(GetMyListingsUseCase(repo)),
      createListingUseCaseProvider.overrideWithValue(CreateListingUseCase(repo)),
      updateListingUseCaseProvider.overrideWithValue(UpdateListingUseCase(repo)),
      deleteListingUseCaseProvider.overrideWithValue(DeleteListingUseCase(repo)),
    ],
  );
}

ProviderContainer createBookingsTestContainer({
  FakeBookingsRepository? bookingsRepository,
}) {
  final repo = bookingsRepository ?? FakeBookingsRepository();

  return ProviderContainer(
    overrides: [
      createBookingUseCaseProvider.overrideWithValue(CreateBookingUseCase(repo)),
      getCustomerBookingsUseCaseProvider.overrideWithValue(
        GetCustomerBookingsUseCase(repo),
      ),
      getIncomingBookingsUseCaseProvider.overrideWithValue(
        GetIncomingBookingsUseCase(repo),
      ),
      getHistoryBookingsUseCaseProvider.overrideWithValue(
        GetHistoryBookingsUseCase(repo),
      ),
      updateBookingStatusUseCaseProvider.overrideWithValue(
        UpdateBookingStatusUseCase(repo),
      ),
      completeBookingUseCaseProvider.overrideWithValue(CompleteBookingUseCase(repo)),
      cancelBookingUseCaseProvider.overrideWithValue(CancelBookingUseCase(repo)),
    ],
  );
}

Future<void> waitForAuthInitialized(ProviderContainer container) async {
  final subscription = container.listen(authProvider, (_, _) {});
  try {
    for (var attempt = 0; attempt < 100; attempt++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      if (subscription.read().initialized) return;
    }
    throw StateError('Auth provider did not initialize in time');
  } finally {
    subscription.close();
  }
}

Future<void> waitForListingsLoaded(ProviderContainer container) async {
  final subscription = container.listen(listingsProvider, (_, _) {});
  try {
    for (var attempt = 0; attempt < 100; attempt++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      if (!subscription.read().isLoading) return;
    }
    throw StateError('Listings provider did not finish loading in time');
  } finally {
    subscription.close();
  }
}
