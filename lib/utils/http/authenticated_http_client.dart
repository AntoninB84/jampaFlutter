import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jampa_flutter/repository/auth_repository.dart';
import 'package:jampa_flutter/utils/constants/env/env.dart';

/// HTTP client wrapper that automatically handles JWT token injection and refresh
///
/// Usage:
/// ```dart
/// final client = AuthenticatedHttpClient(authRepository);
/// final response = await client.get(Uri.parse('$baseUrl/api/endpoint'));
/// ```
class AuthenticatedHttpClient {
  final AuthRepository _authRepository;
  final http.Client _client;
  final String _apiKey;

  AuthenticatedHttpClient({
    required AuthRepository authRepository,
    http.Client? client,
    String? apiKey,
  })  : _authRepository = authRepository,
        _client = client ?? http.Client(),
        _apiKey = apiKey ?? Env.apiKey;

  /// GET request with automatic token handling
  Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    return _requestWithAuth(
      () async => _client.get(url, headers:  await _buildHeaders(headers)),
    );
  }

  /// POST request with automatic token handling
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    String? encoding,
  }) async {
    return _requestWithAuth(
      () async => _client.post(
        url,
        headers: await _buildHeaders(headers),
        body: body,
        encoding: encoding != null ? Encoding.getByName(encoding) : null,
      ),
    );
  }

  /// PUT request with automatic token handling
  Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    String? encoding,
  }) async {
    return _requestWithAuth(
      () async => _client.put(
        url,
        headers: await _buildHeaders(headers),
        body: body,
        encoding: encoding != null ? Encoding.getByName(encoding) : null,
      ),
    );
  }

  /// DELETE request with automatic token handling
  Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    String? encoding,
  }) async {
    return _requestWithAuth(
      () async => _client.delete(
        url,
        headers: await _buildHeaders(headers),
        body: body,
        encoding: encoding != null ? Encoding.getByName(encoding) : null,
      ),
    );
  }

  /// PATCH request with automatic token handling
  Future<http.Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    String? encoding,
  }) async {
    return _requestWithAuth(
      () async => _client.patch(
        url,
        headers: await _buildHeaders(headers),
        body: body,
        encoding: encoding != null ? Encoding.getByName(encoding) : null,
      ),
    );
  }

  /// Execute a request with automatic token refresh on 401
  Future<http.Response> _requestWithAuth(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request();

      // If unauthorized, try to refresh token and retry once
      if (response.statusCode == 401) {
        await _authRepository.refreshToken();
        return await request();
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Build headers with authentication token
  Future<Map<String, String>> _buildHeaders(
    Map<String, String>? customHeaders,
  ) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'X-API-Key': _apiKey,
      ...?customHeaders,
    };

    // Add authorization header if token is available
    final token = await _authRepository.getAccessToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Close the underlying HTTP client
  void close() {
    _client.close();
  }
}

/// Example usage in a repository
///
/// ```dart
/// class UserApiRepository {
///   final AuthenticatedHttpClient _client;
///
///   UserApiRepository(AuthRepository authRepository)
///       : _client = AuthenticatedHttpClient(authRepository: authRepository);
///
///   Future<Map<String, dynamic>> getUserProfile() async {
///     final response = await _client.get(
///       Uri.parse('${Env.apiUrlDev}/api/user/profile'),
///     );
///
///     if (response.statusCode == 200) {
///       return jsonDecode(response.body);
///     }
///
///     throw Exception('Failed to load user profile');
///   }
///
///   Future<void> updateUserProfile(Map<String, dynamic> data) async {
///     final response = await _client.put(
///       Uri.parse('${Env.apiUrlDev}/api/user/profile'),
///       body: jsonEncode(data),
///     );
///
///     if (response.statusCode != 200) {
///       throw Exception('Failed to update user profile');
///     }
///   }
/// }
/// ```

