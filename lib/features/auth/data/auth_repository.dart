import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/exceptions/api_exception.dart';
import '../../../core/models/user_model.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/dio_client.dart';

part 'auth_repository.g.dart';

// Use standard camelCase for the function name so it generates cleanly
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    ref.watch(dioProvider),
    ref.watch(secureStorageProvider),
  );
}

class AuthRepository {
  static const _userCacheKey = 'cached_user_json';

  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthRepository(this._dio, this._storage);

  Future<UserModel> register({
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
    try {
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
      return _persistSession(res.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    } catch (e) {
      throw AppException(
        message: 'Could not save session: $e',
        code: 'STORAGE_ERROR',
      );
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
    required bool isProvider,
  }) async {
    final path = isProvider
        ? ApiConstants.authLoginProvider
        : ApiConstants.authLoginCustomer;
    try {
      final res = await _dio.post(
        path,
        data: {'email': email, 'password': password},
      );
      return _persistSession(res.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiExceptionMapper.fromDio(e);
    } catch (e) {
      throw AppException(
        message: 'Could not save session: $e',
        code: 'STORAGE_ERROR',
      );
    }
  }

  Future<UserModel?> restoreSession() async {
    try {
      final token = await _storage.read(key: 'access_token');
      if (token == null || token.isEmpty) return null;
      try {
        final res = await _dio.get(ApiConstants.authMe);
        final user = UserModel.fromJson(
          res.data['data'] as Map<String, dynamic>,
        );

        await _cacheUser(user);
        return user;
      } on DioException catch (_) {
        return _getCachedUser();
      }
    } catch (_) {
      return _getCachedUser();
    }
  }

  Future<UserModel?> _getCachedUser() async {
    final raw = await _storage.read(key: _userCacheKey);
    if (raw == null || raw.isEmpty) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<UserModel> _persistSession(Map<String, dynamic> data) async {
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    await _storage.write(
      key: 'access_token',
      value: data['accessToken'] as String,
    );
    await _storage.write(
      key: 'refresh_token',
      value: data['refreshToken'] as String,
    );
    await _cacheUser(user);
    return user;
  }

  Future<void> updateCachedUser(UserModel user) async {
    await _cacheUser(user);
  }

  Future<void> _cacheUser(UserModel user) async {
    await _storage.write(key: _userCacheKey, value: jsonEncode(user.toJson()));
    await _storage.write(key: _userCacheKey, value: jsonEncode(user.toJson()));
  }
}
