import '../entities/user_entity.dart';

abstract class AuthRepositoryContract {
  Future<UserEntity> register({
    required String email,
    required String password,
    required String displayName,
    required bool isProvider,
    String? phone,
    String? profession,
  });

  Future<UserEntity> login({
    required String email,
    required String password,
    required bool isProvider,
  });

  Future<UserEntity?> restoreSession();

  Future<void> logout();
}
