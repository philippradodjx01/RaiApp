import 'package:flutter/foundation.dart';

class ApiConfig {
  // Set API_BASE_URL at build time for deployed apps and physical devices.
  // Local desktop/web builds use localhost. Android emulators use the host alias.
  static const _configuredBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl => _configuredBaseUrl.isNotEmpty
      ? _configuredBaseUrl.replaceFirst(RegExp(r'/+$'), '')
      : kIsWeb
          ? 'http://192.168.0.61:8000/api/v1'
          : defaultTargetPlatform == TargetPlatform.android
              ? 'http://192.168.0.61:8000/api/v1'
              : 'http://192.168.0.61:8000/api/v1';
}
