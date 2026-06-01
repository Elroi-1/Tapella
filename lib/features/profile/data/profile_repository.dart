import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/exceptions/api_exception.dart';
import '../../../core/models/user_model.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/domain/repositories/profile_repository.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/data/datasources/remote/auth_remote_datasource.dart';

part 'profile_repository.g.dart';

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(
    AuthRemoteDataSource(ref.watch(dioProvider)),
    ref.watch(authRepositoryProvider),
  );
}

class ProfileRepository implements ProfileRepositoryContract {
  final AuthRemoteDataSource _remote;
  final AuthRepository _authRepo;

  ProfileRepository(this._remote, this._authRepo);

  @override
  Future<UserModel> fetchProfile() async {
    try {
      final data = await _remote.fetchProfile();
      final user = UserModel.fromJson(data);
      await _authRepo.updateCachedUser(user);
      return user;
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String displayName,
    required String email,
    String? phone,
    String? location,
    String? bio,
    String? profileImage,
    String? profession,
  }) async {
    try {
      final data = await _remote.updateProfile(
        displayName: displayName,
        email: email,
        phone: phone,
        location: location,
        bio: bio,
        profileImage: profileImage,
        profession: profession,
      );
      final user = UserModel.fromJson(data);
      await _authRepo.updateCachedUser(user);
      return user;
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _remote.deleteAccount();
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    }
  }
}
