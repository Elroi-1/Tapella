import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../repositories/profile_repository.dart';

class RegisterUseCase {
  final AuthRepositoryContract repository;
  RegisterUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
    required String displayName,
    required bool isProvider,
    String? phone,
    String? profession,
  }) {
    return repository.register(
      email: email,
      password: password,
      displayName: displayName,
      isProvider: isProvider,
      phone: phone,
      profession: profession,
    );
  }
}

class LoginUseCase {
  final AuthRepositoryContract repository;
  LoginUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
    required bool isProvider,
  }) {
    return repository.login(
      email: email,
      password: password,
      isProvider: isProvider,
    );
  }
}

class RestoreSessionUseCase {
  final AuthRepositoryContract repository;
  RestoreSessionUseCase(this.repository);

  Future<UserEntity?> call() {
    return repository.restoreSession();
  }
}

class LogoutUseCase {
  final AuthRepositoryContract repository;
  LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}

class FetchProfileUseCase {
  final ProfileRepositoryContract repository;
  FetchProfileUseCase(this.repository);

  Future<UserEntity> call() {
    return repository.fetchProfile();
  }
}

class UpdateProfileUseCase {
  final ProfileRepositoryContract repository;
  UpdateProfileUseCase(this.repository);

  Future<UserEntity> call({
    required String displayName,
    required String email,
    String? phone,
    String? location,
    String? bio,
    String? profileImage,
    String? profession,
  }) {
    return repository.updateProfile(
      displayName: displayName,
      email: email,
      phone: phone,
      location: location,
      bio: bio,
      profileImage: profileImage,
      profession: profession,
    );
  }
}

class DeleteAccountUseCase {
  final ProfileRepositoryContract repository;
  DeleteAccountUseCase(this.repository);

  Future<void> call() {
    return repository.deleteAccount();
  }
}
