import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'api_constants.dart';
import 'auth_interceptor.dart';

part 'dio_client.g.dart';

@riverpod
FlutterSecureStorage secureStorage(Ref ref) => const FlutterSecureStorage();

@riverpod
Dio dio(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  dio.interceptors.add(AuthInterceptor(storage, dio));
  return dio;
}
