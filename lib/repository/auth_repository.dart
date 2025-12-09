import 'dart:async';

import 'package:jampa_flutter/data/api/auth_api_client.dart';
import 'package:jampa_flutter/data/models/auth/auth_response.dart';
import 'package:jampa_flutter/utils/storage/secure_storage_service.dart';
import 'package:rxdart/rxdart.dart';

/// Possible authentication statuses
enum AuthStatus { unknown, authenticated, unauthenticated }

/// Authentication repository that manages user authentication with backend API
class AuthRepository {
  final AuthApiClient _apiClient;
  final SecureStorageService _secureStorage;
  final _controller = BehaviorSubject<AuthStatus>.seeded(AuthStatus.unknown);
  AuthStatus _currentStatus = AuthStatus.unknown;

  AuthRepository({
    AuthApiClient? apiClient,
    SecureStorageService? secureStorage,
  })  : _apiClient = apiClient ?? AuthApiClient(),
        _secureStorage = secureStorage ?? SecureStorageService() {
    // Initialize current status asynchronously
    _initializeStatus();
  }

  /// Get the current authentication status
  AuthStatus get currentStatus => _currentStatus;

  /// Initialize the current status from secure storage
  Future<void> _initializeStatus() async {
    final isAuthenticated = await _secureStorage.isAuthenticated();
    _currentStatus = isAuthenticated ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    // Emit initial status to the stream
    _controller.add(_currentStatus);
  }

  /// Stream of authentication status changes
  /// BehaviorSubject ensures new listeners get the latest value immediately
  Stream<AuthStatus> get status => _controller.stream;

  /// Register a new user
  Future<UserData> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.register(
        username: username,
        email: email,
        password: password,
      );

      await _saveAuthData(response);
      _currentStatus = AuthStatus.authenticated;
      _controller.add(AuthStatus.authenticated);
      return response.user;
    } catch (e) {
      throw AuthException('Registration failed: ${e.toString()}');
    }
  }

  /// Log in an existing user
  Future<UserData> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.login(
        email: email,
        password: password,
      );

      await _saveAuthData(response);
      _currentStatus = AuthStatus.authenticated;
      _controller.add(AuthStatus.authenticated);
      return response.user;
    } catch (e) {
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  /// Refresh the access token
  Future<void> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) {
        throw AuthException('No refresh token available');
      }

      final response = await _apiClient.refresh(refreshToken);
      await _saveAuthData(response);
    } catch (e) {
      // If refresh fails, log out the user
      await logOut();
      throw AuthException('Token refresh failed: ${e.toString()}');
    }
  }

  /// Get the current access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.getAccessToken();
  }

  /// Log out the current user
  Future<void> logOut() async {
    await _secureStorage.clearAuthData();
    _currentStatus = AuthStatus.unauthenticated;
    _controller.add(AuthStatus.unauthenticated);
  }

  /// Save authentication data to secure storage
  Future<void> _saveAuthData(AuthResponse response) async {
    await _secureStorage.saveAuthData(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      userId: response.user.id,
    );
  }

  /// Closes the stream controller
  void dispose() => _controller.close();
}

/// Exception thrown when authentication fails
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}
