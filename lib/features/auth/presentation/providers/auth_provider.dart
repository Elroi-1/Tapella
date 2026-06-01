import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/exceptions/api_exception.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../data/auth_repository.dart';
import '../../../profile/data/profile_repository.dart';

part 'auth_provider.g.dart';

@riverpod
RegisterUseCase registerUseCase(Ref ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
RestoreSessionUseCase restoreSessionUseCase(Ref ref) {
  return RestoreSessionUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
FetchProfileUseCase fetchProfileUseCase(Ref ref) {
  return FetchProfileUseCase(ref.watch(profileRepositoryProvider));
}

@riverpod
UpdateProfileUseCase updateProfileUseCase(Ref ref) {
  return UpdateProfileUseCase(ref.watch(profileRepositoryProvider));
}

@riverpod
DeleteAccountUseCase deleteAccountUseCase(Ref ref) {
  return DeleteAccountUseCase(ref.watch(profileRepositoryProvider));
}

class AuthState {
  final UserEntity? user;
  final bool isSubmitting;
  final String? error;
  final bool initialized;

  const AuthState({
    this.user,
    this.isSubmitting = false,
    this.error,
    this.initialized = false,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserEntity? user,
    bool? isSubmitting,
    String? error,
    bool? initialized,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
      initialized: initialized ?? this.initialized,
    );
  }
}

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    Future.microtask(_restore);
    return const AuthState();
  }

  Future<void> _restore() async {
    try {
      final user = await ref
          .read(restoreSessionUseCaseProvider)
          .call()
          .timeout(const Duration(seconds: 8));
      if (!ref.mounted) return;
      state = AuthState(user: user, initialized: true);
    } catch (_) {
      if (!ref.mounted) return;
      state = const AuthState(initialized: true);
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    required bool isProvider,
  }) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final user = await ref
          .read(loginUseCaseProvider)
          .call(email: email, password: password, isProvider: isProvider);
      state = AuthState(user: user, initialized: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: _message(e),
        initialized: true,
      );
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String displayName,
    required bool isProvider,
    String? phone,
    String? profession,
  }) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final user = await ref
          .read(registerUseCaseProvider)
          .call(
            email: email,
            password: password,
            displayName: displayName,
            isProvider: isProvider,
            phone: phone,
            profession: profession,
          );
      state = AuthState(user: user, initialized: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: _message(e),
        initialized: true,
      );
      return false;
    }
  }

  String _message(Object e) {
    if (e is AppException) return e.message;
    return 'Cannot reach server. Is it running on port 3000?';
  }

  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider).call();
    state = const AuthState(initialized: true);
  }

  void setUser(UserEntity user) {
    state = AuthState(user: user, initialized: true);
  }

  Future<UserEntity?> refreshProfile() async {
    try {
      final user = await ref.read(fetchProfileUseCaseProvider).call();
      state = AuthState(user: user, initialized: true);
      return user;
    } catch (_) {
      return null;
    }
  }

  Future<UserEntity?> updateProfile({
    required String displayName,
    required String email,
    String? phone,
    String? location,
    String? bio,
    String? profileImage,
    String? profession,
  }) async {
    try {
      final user = await ref.read(updateProfileUseCaseProvider).call(
            displayName: displayName,
            email: email,
            phone: phone,
            location: location,
            bio: bio,
            profileImage: profileImage,
            profession: profession,
          );
      state = AuthState(user: user, initialized: true);
      return user;
    } catch (e) {
      state = state.copyWith(error: _message(e));
      return null;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      await ref.read(deleteAccountUseCaseProvider).call();
      await ref.read(logoutUseCaseProvider).call();
      state = const AuthState(initialized: true);
      return true;
    } catch (e) {
      state = state.copyWith(error: _message(e));
      return false;
    }
  }
}
