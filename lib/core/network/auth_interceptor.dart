import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Dio _dio;

  AuthInterceptor(this._storage, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: 'access_token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refresh = await _storage.read(key: 'refresh_token');
      if (refresh != null) {
        try {
          final res = await _dio.post(
            '/auth/refresh',
            data: {'refreshToken': refresh},
            options: Options(headers: {'Authorization': null}),
          );
          final data = res.data['data'] as Map<String, dynamic>;
          await _storage.write(
            key: 'access_token',
            value: data['accessToken'] as String,
          );
          await _storage.write(
            key: 'refresh_token',
            value: data['refreshToken'] as String,
          );
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer ${data['accessToken']}';
          final clone = await _dio.fetch(opts);
          return handler.resolve(clone);
        } catch (_) {
          await _storage.deleteAll();
        }
      }
    }
    handler.next(err);
  }
}
