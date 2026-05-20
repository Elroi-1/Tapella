import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final String code;
  final int? statusCode;

  const AppException({
    required this.message,
    this.code = 'UNKNOWN',
    this.statusCode,
  });

  @override
  String toString() => message;
}

class ApiExceptionMapper {
  static AppException fromDio(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const AppException(
        message: 'Cannot reach server. Showing saved data if available.',
        code: 'OFFLINE',
      );
    }
    final data = e.response?.data;
    if (data is Map && data['error'] is Map) {
      final err = data['error'] as Map;
      return AppException(
        message: err['message']?.toString() ?? 'Request failed',
        code: err['code']?.toString() ?? 'API_ERROR',
        statusCode: e.response?.statusCode,
      );
    }
    return AppException(
      message: e.message ?? 'Network error',
      code: 'NETWORK_ERROR',
      statusCode: e.response?.statusCode,
    );
  }
}
