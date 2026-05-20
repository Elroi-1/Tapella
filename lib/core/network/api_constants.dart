import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class ApiConstants {
  /// API base URL for the current platform.
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:4000/api/v1';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Android emulator → host machine
      return 'http://10.0.2.2:4000/api/v1';
    }
    return 'http://localhost:4000/api/v1';
  }

  static const authRegisterCustomer = '/auth/register/customer';
  static const authRegisterProvider = '/auth/register/provider';
  static const authLoginCustomer = '/auth/login/customer';
  static const authLoginProvider = '/auth/login/provider';
  static const authRefresh = '/auth/refresh';
  static const authMe = '/auth/me';
  static const authProfile = '/auth/profile';
  static const authDeleteAccount = '/auth/account';
  static const health = '/health';
  static const listings = '/listings';
  static const bookings = '/bookings';
  static const reviews = '/reviews';
}
