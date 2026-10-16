import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scaffold_eng_mobile/core/api_config.dart';

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('uses the Android emulator host for the local API by default', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(ApiConfig.baseUrl, 'http://10.0.2.2:8000/api/v1');
  });

  test('uses localhost for the desktop API by default', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    expect(ApiConfig.baseUrl, 'http://localhost:8000/api/v1');
  });
}
