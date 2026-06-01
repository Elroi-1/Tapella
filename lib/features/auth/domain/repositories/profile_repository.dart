import '../entities/user_entity.dart';

abstract class ProfileRepositoryContract {
  Future<UserEntity> fetchProfile();

  Future<UserEntity> updateProfile({
    required String displayName,
    required String email,
    String? phone,
    String? location,
    String? bio,
    String? profileImage,
    String? profession,
  });

  Future<void> deleteAccount();
}
