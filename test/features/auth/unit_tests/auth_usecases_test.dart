import 'package:flutter_test/flutter_test.dart';
import 'package:tapella/core/exceptions/api_exception.dart';
import 'package:tapella/features/auth/domain/entities/user_entity.dart';
import 'package:tapella/features/auth/domain/usecases/auth_usecases.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/fixtures.dart';

void main() {
  late FakeAuthRepository authRepository;
  late FakeProfileRepository profileRepository;

  setUp(() {
    authRepository = FakeAuthRepository();
    profileRepository = FakeProfileRepository();
  });

  group('LoginUseCase', () {
    test('delegates credentials to repository and returns user', () async {
      authRepository.loginResult = Fixtures.customer;
      final useCase = LoginUseCase(authRepository);

      final result = await useCase.call(
        email: 'customer@tapella.test',
        password: 'secret',
        isProvider: false,
      );

      expect(result, Fixtures.customer);
      expect(authRepository.lastLoginEmail, 'customer@tapella.test');
      expect(authRepository.lastLoginPassword, 'secret');
      expect(authRepository.lastLoginIsProvider, false);
    });

    test('propagates repository errors', () async {
      authRepository.loginError = const AppException(
        message: 'Invalid credentials',
        code: 'AUTH_ERROR',
      );
      final useCase = LoginUseCase(authRepository);

      expect(
        () => useCase.call(
          email: 'bad@tapella.test',
          password: 'wrong',
          isProvider: false,
        ),
        throwsA(isA<AppException>()),
      );
    });
  });

  group('RegisterUseCase', () {
    test('delegates registration fields to repository', () async {
      authRepository.registerResult = Fixtures.provider;
      final useCase = RegisterUseCase(authRepository);

      final result = await useCase.call(
        email: 'provider@tapella.test',
        password: 'secret',
        displayName: 'Test Provider',
        isProvider: true,
        profession: 'Plumbing',
      );

      expect(result, Fixtures.provider);
    });
  });

  group('RestoreSessionUseCase', () {
    test('returns restored user when session exists', () async {
      authRepository.restoreSessionResult = Fixtures.customer;
      final useCase = RestoreSessionUseCase(authRepository);

      final result = await useCase.call();

      expect(result, Fixtures.customer);
    });

    test('returns null when no session exists', () async {
      authRepository.restoreSessionResult = null;
      final useCase = RestoreSessionUseCase(authRepository);

      final result = await useCase.call();

      expect(result, isNull);
    });
  });

  group('LogoutUseCase', () {
    test('calls repository logout', () async {
      final useCase = LogoutUseCase(authRepository);

      await useCase.call();

      expect(authRepository.logoutCalled, isTrue);
    });
  });

  group('FetchProfileUseCase', () {
    test('returns profile from repository', () async {
      profileRepository.fetchProfileResult = Fixtures.customer;
      final useCase = FetchProfileUseCase(profileRepository);

      final result = await useCase.call();

      expect(result, Fixtures.customer);
    });
  });

  group('UpdateProfileUseCase', () {
    test('delegates profile fields to repository', () async {
      profileRepository.updateProfileResult = UserEntity(
        id: Fixtures.customer.id,
        email: Fixtures.customer.email,
        role: Fixtures.customer.role,
        displayName: 'Updated Name',
        phone: Fixtures.customer.phone,
      );
      final useCase = UpdateProfileUseCase(profileRepository);

      final result = await useCase.call(
        displayName: 'Updated Name',
        email: Fixtures.customer.email,
        phone: Fixtures.customer.phone,
      );

      expect(result.displayName, 'Updated Name');
      expect(profileRepository.lastUpdateDisplayName, 'Updated Name');
      expect(profileRepository.lastUpdateEmail, Fixtures.customer.email);
    });
  });

  group('DeleteAccountUseCase', () {
    test('calls repository deleteAccount', () async {
      final useCase = DeleteAccountUseCase(profileRepository);

      await useCase.call();

      expect(profileRepository.deleteAccountCalled, isTrue);
    });
  });
}
