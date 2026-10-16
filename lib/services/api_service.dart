import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, [this.statusCode]);
  @override
  String toString() => message;
}

class ApiService {
  static const _tokenKey = 'scaffold_token';
  final http.Client _client;
  ApiService({http.Client? client}) : _client = client ?? http.Client();
  Future<String?> get token async =>
      (await SharedPreferences.getInstance()).getString(_tokenKey);
  Future<void> saveToken(String value) async =>
      (await SharedPreferences.getInstance()).setString(_tokenKey, value);
  Future<void> clearToken() async =>
      (await SharedPreferences.getInstance()).remove(_tokenKey);
  Future<void> logout() async {
    try {
      await post('/auth/logout');
    } finally {
      await clearToken();
    }
  }

  Future<Map<String, String>> _headers() async {
    final value = await token;
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (value != null) 'Authorization': 'Bearer $value',
    };
  }

  Future<dynamic> get(String path) async => _send('GET', path);
  Future<dynamic> post(
    String path, [
    Map<String, dynamic> body = const {},
  ]) async =>
      _send('POST', path, body);
  Future<dynamic> put(
    String path, [
    Map<String, dynamic> body = const {},
  ]) async =>
      _send('PUT', path, body);
  Future<dynamic> patch(
    String path, [
    Map<String, dynamic> body = const {},
  ]) async =>
      _send('PATCH', path, body);
  Future<dynamic> delete(String path) async => _send('DELETE', path);
  Future<dynamic> _send(
    String method,
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final headers = await _headers();
    http.Response response;
    try {
      switch (method) {
        case 'GET':
          response = await _client
              .get(uri, headers: headers)
              .timeout(const Duration(seconds: 20));
          break;
        case 'POST':
          response = await _client
              .post(uri, headers: headers, body: jsonEncode(body))
              .timeout(const Duration(seconds: 20));
          break;
        case 'PUT':
          response = await _client
              .put(uri, headers: headers, body: jsonEncode(body))
              .timeout(const Duration(seconds: 20));
          break;
        case 'PATCH':
          response = await _client
              .patch(uri, headers: headers, body: jsonEncode(body))
              .timeout(const Duration(seconds: 20));
          break;
        default:
          response = await _client
              .delete(uri, headers: headers)
              .timeout(const Duration(seconds: 20));
      }
    } on Exception catch (e) {
      throw ApiException(
        'Could not reach the learning server at ${ApiConfig.baseUrl}. Check that the server is running and reachable from this device. ($e)',
      );
    }
    final data = jsonDecode(response.body.isEmpty ? '{}' : response.body);
    if (response.statusCode == 401) {
      await clearToken();
      throw ApiException('Your session expired. Please sign in again.', 401);
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final errors = data['errors'];
      final message = errors is Map
          ? errors.values.expand((e) => e is List ? e : [e]).join('\n')
          : data['message'] ?? 'Request failed.';
      throw ApiException(message, response.statusCode);
    }
    return data['data'];
  }

  Future<Map<String, dynamic>> login(String login, String password) async {
    final result = await post('/auth/login', {
      'login': login,
      'password': password,
    });
    await saveToken(result['token']);
    return Map<String, dynamic>.from(result['user']);
  }

  Future<Map<String, dynamic>> register(String name, String email,
      String studentId, String password, String confirmation) async {
    final result = await post('/auth/register', {
      'name': name,
      'email': email,
      if (studentId.trim().isNotEmpty) 'student_id': studentId.trim(),
      'password': password,
      'password_confirmation': confirmation,
    });
    await saveToken(result['token']);
    return Map<String, dynamic>.from(result['user']);
  }

  Future<Map<String, dynamic>> profile() async =>
      Map<String, dynamic>.from(await get('/me'));
}
