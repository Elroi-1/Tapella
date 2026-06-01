import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String displayName,
    required bool isProvider,
    String? phone,
    String? profession,
  }) async {
    final path = isProvider
        ? ApiConstants.authRegisterProvider
        : ApiConstants.authRegisterCustomer;
    final res = await _dio.post(
      path,
      data: {
        'email': email,
        'password': password,
        'displayName': displayName,
        'phone': ?phone,
        'profession': ?profession,
      },
    );
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required bool isProvider,
  }) async {
    final path = isProvider
        ? ApiConstants.authLoginProvider
        : ApiConstants.authLoginCustomer;
    final res = await _dio.post(
      path,
      data: {'email': email, 'password': password},
    );
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    final res = await _dio.get(ApiConstants.authMe);
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateProfile({
    required String displayName,
    required String email,
    String? phone,
    String? location,
    String? bio,
    String? profileImage,
    String? profession,
  }) async {
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
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<void> deleteAccount() async {
    await _dio.delete(ApiConstants.authDeleteAccount);
  }
}
