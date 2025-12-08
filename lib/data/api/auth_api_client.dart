import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jampa_flutter/utils/constants/env/env.dart';
import 'package:jampa_flutter/utils/helpers/flavors.dart';
import '../models/auth/auth_request.dart';
import '../models/auth/auth_response.dart';

/// API client for authentication endpoints
class AuthApiClient {
  final http.Client _client;
  final String _baseUrl;
  final String _apiKey;

  AuthApiClient({
    http.Client? client,
    String? baseUrl,
    String? apiKey,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? (
            FlavorConfig.appFlavor.isProduction ? Env.apiUrlProd : Env.apiUrlDev
        ),
        _apiKey = apiKey ?? Env.apiKey;

  /// Register a new user
  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final request = RegisterRequest(
      username: username,
      email: email,
      password: password,
    );

    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {
        'Content-Type': 'application/json',
        'X-API-Key': _apiKey,
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw AuthApiException(
        statusCode: response.statusCode,
        message: _extractErrorMessage(response),
      );
    }
  }

  /// Login an existing user
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequest(
      email: email,
      password: password,
    );

    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'X-API-Key': _apiKey,
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw AuthApiException(
        statusCode: response.statusCode,
        message: _extractErrorMessage(response),
      );
    }
  }

  /// Refresh the access token using the refresh token
  Future<AuthResponse> refresh(String refreshToken) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/refresh'),
      headers: {
        'Content-Type': 'application/json',
        'X-API-Key': _apiKey,
        'Authorization': 'Bearer $refreshToken',
      },
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw AuthApiException(
        statusCode: response.statusCode,
        message: _extractErrorMessage(response),
      );
    }
  }

  /// Extract error message from response
  String _extractErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body['message'] ?? body['error'] ?? 'Authentication failed';
    } catch (_) {
      return 'Authentication failed';
    }
  }
}

/// Exception thrown when authentication API call fails
class AuthApiException implements Exception {
  final int statusCode;
  final String message;

  AuthApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() => 'AuthApiException: $message (Status: $statusCode)';
}

