import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jampa_flutter/data/models/sync/sync_request.dart';
import 'package:jampa_flutter/data/models/sync/sync_response.dart';
import 'package:jampa_flutter/utils/constants/env/env.dart';
import 'package:jampa_flutter/utils/helpers/flavors.dart';

/// API client for synchronization endpoints
class SyncApiClient {
  final http.Client _client;
  final String _baseUrl;
  final String _apiKey;
  final Future<String> Function() _getAccessToken;

  SyncApiClient({
    http.Client? client,
    String? baseUrl,
    String? apiKey,
    required Future<String> Function() getAccessToken,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ??
            (FlavorConfig.appFlavor.isProduction
                ? Env.apiUrlProd
                : Env.apiUrlDev),
        _apiKey = apiKey ?? Env.apiKey,
        _getAccessToken = getAccessToken;

  /// Perform synchronization with the backend
  Future<SyncResponse> sync(SyncRequest request) async {
    final accessToken = await _getAccessToken();
    if (accessToken.isEmpty) {
      throw SyncApiException(
        statusCode: 401,
        message: 'Not authenticated',
      );
    }

    final response = await _client.post(
      Uri.parse('$_baseUrl/sync'),
      headers: {
        'Content-Type': 'application/json',
        'X-API-Key': _apiKey,
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return SyncResponse.fromJson(jsonDecode(response.body));
    } else {
      throw SyncApiException(
        statusCode: response.statusCode,
        message: _extractErrorMessage(response),
      );
    }
  }

  /// Extract error message from response
  String _extractErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body['message'] ?? body['error'] ?? 'Synchronization failed';
    } catch (_) {
      return 'Synchronization failed';
    }
  }
}

/// Exception thrown when sync API call fails
class SyncApiException implements Exception {
  final int statusCode;
  final String message;

  SyncApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() => 'SyncApiException: $message (Status: $statusCode)';
}

