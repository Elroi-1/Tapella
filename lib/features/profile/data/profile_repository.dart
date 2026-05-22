import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/exceptions/api_exception.dart';
import '../../../core/models/user_model.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/data/auth_repository.dart';

part 'profile_repository.g.dart';

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(
    ref.watch(dioProvider),
    ref.watch(authRepositoryProvider),
  );
}

class ProfileRepository {
  final Dio _dio;
  final AuthRepository _authRepo;

  ProfileRepository(this._dio, this._authRepo);

  Future<UserModel> fetchProfile() async {
    try {
      final res = await _dio.get(ApiConstants.authMe);
      final user = UserModel.fromJson(res.data['data'] as Map<String, dynamic>);
      await _authRepo.updateCachedUser(user);
      return user;
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    }
  }

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
      final res = await _dio.patch(
        ApiConstants.authProfile,
        data: {
          'displayName': displayName,
          'email': email,
          'phone': ?phone,
          'location': ?location,
          'bio': ?bio,
          'profileImage': ?profileImage,
          'profession': ?profession,
        },
      );
      final user = UserModel.fromJson(res.data['data'] as Map<String, dynamic>);
      await _authRepo.updateCachedUser(user);
      return user;
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _dio.delete(ApiConstants.authDeleteAccount);
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    }
  }
}
