import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tapella/core/exceptions/api_exception.dart';
import 'package:tapella/features/auth/presentation/providers/auth_provider.dart';

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/fixtures.dart';
import '../../../../helpers/riverpod_test_helpers.dart';

void main() {
  late FakeAuthRepository authRepository;
  late FakeProfileRepository profileRepository;
  late ProviderContainer container;

  setUp(() {
    authRepository = FakeAuthRepository();
    profileRepository = FakeProfileRepository();
    container = createAuthTestContainer(
      authRepository: authRepository,
      profileRepository: profileRepository,
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('Auth provider', () {
    test('initializes with no user when session restore returns null', () async {
      authRepository.restoreSessionResult = null;

      container.read(authProvider);
      await waitForAuthInitialized(container);

      final state = container.read(authProvider);
      expect(state.initialized, isTrue);
      expect(state.isAuthenticated, isFalse);
      expect(state.user, isNull);
    });

    test('restores existing session on startup', () async {
      authRepository.restoreSessionResult = Fixtures.customer;

      container.read(authProvider);
      await waitForAuthInitialized(container);

      final state = container.read(authProvider);
      expect(state.user, Fixtures.customer);
      expect(state.isAuthenticated, isTrue);
    });

    test('login updates state with authenticated user', () async {
      authRepository.restoreSessionResult = null;
      authRepository.loginResult = Fixtures.customer;

      container.read(authProvider);
      await waitForAuthInitialized(container);

      final success = await container.read(authProvider.notifier).login(
            email: 'customer@tapella.test',
            password: 'secret',
            isProvider: false,
          );

      final state = container.read(authProvider);
      expect(success, isTrue);
      expect(state.user, Fixtures.customer);
      expect(state.error, isNull);
      expect(state.isSubmitting, isFalse);
    });

    test('login stores error message when use case fails', () async {
      authRepository.restoreSessionResult = null;
      authRepository.loginError = const AppException(
        message: 'Invalid credentials',
        code: 'AUTH_ERROR',
      );

      container.read(authProvider);
      await waitForAuthInitialized(container);

      final success = await container.read(authProvider.notifier).login(
            email: 'bad@tapella.test',
            password: 'wrong',
            isProvider: false,
          );

      final state = container.read(authProvider);
      expect(success, isFalse);
      expect(state.error, 'Invalid credentials');
      expect(state.isAuthenticated, isFalse);
    });

    test('logout clears user and keeps initialized state', () async {
      authRepository.restoreSessionResult = Fixtures.customer;

      container.read(authProvider);
      await waitForAuthInitialized(container);

      await container.read(authProvider.notifier).logout();

      final state = container.read(authProvider);
      expect(state.user, isNull);
      expect(state.initialized, isTrue);
      expect(authRepository.logoutCalled, isTrue);
    });

    test('updateProfile updates user in state', () async {
      authRepository.restoreSessionResult = Fixtures.customer;
      profileRepository.updateProfileResult = Fixtures.customer;

      container.read(authProvider);
      await waitForAuthInitialized(container);

      final updated = await container.read(authProvider.notifier).updateProfile(
            displayName: 'Updated Name',
            email: Fixtures.customer.email,
          );

      expect(updated, Fixtures.customer);
      expect(container.read(authProvider).user, Fixtures.customer);
    });

    test('deleteAccount clears session after successful deletion', () async {
      authRepository.restoreSessionResult = Fixtures.customer;

      container.read(authProvider);
      await waitForAuthInitialized(container);

      final success =
          await container.read(authProvider.notifier).deleteAccount();

      expect(success, isTrue);
      expect(profileRepository.deleteAccountCalled, isTrue);
      expect(authRepository.logoutCalled, isTrue);
      expect(container.read(authProvider).isAuthenticated, isFalse);
    });
  });
}
