import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../data/database.dart';
import '../../data/models/auth/auth_response.dart';
import '../../data/models/user/user.dart';
import '../../repository/auth_repository.dart';
import '../../repository/sync_repository.dart';
import '../../repository/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// This Bloc handles the authentication state of the user.
/// It listens to the AuthRepository for changes in authentication status
/// and updates the AuthState accordingly.
///
/// It handles registration, login, logout, and token refresh events.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState.unknown()) {
    on<AuthVerificationRequested>(_onSubscriptionRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutPressed>(_onLogoutPressed);
    on<AuthTokenRefreshRequested>(_onTokenRefreshRequested);
  }

  final AuthRepository _authRepository = serviceLocator<AuthRepository>();
  final UserRepository _userRepository = serviceLocator<UserRepository>();
  final AppDatabase _database = serviceLocator<AppDatabase>();
  final SyncRepository _syncRepository = serviceLocator<SyncRepository>();

  /// Subscribes to the authentication status stream from the AuthRepository.
  Future<void> _onSubscriptionRequested(
    AuthVerificationRequested event,
    Emitter<AuthState> emit,
  ) {
    return emit.onEach(
      _authRepository.status,
      onData: (status) async {
        switch (status) {
          case AuthStatus.unauthenticated:
            return emit(const AuthState.unauthenticated());
          case AuthStatus.authenticated:
            final user = await _tryGetUser();
            return emit(
              user != null
                  ? AuthState.authenticated(user)
                  : const AuthState.unauthenticated(),
            );
          case AuthStatus.unknown:
            return emit(const AuthState.unknown());
        }
      },
      onError: addError,
    );
  }

  /// Handles the login request event
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final userData = await _authRepository.logIn(
        email: event.email,
        password: event.password,
      );

      // Save user to database
      await _saveUserFromAuthData(userData);

      // State will be updated by the status stream subscription
    } catch (e) {
      emit(AuthState.error(e.toString()));
      emit(const AuthState.unauthenticated());
    }
  }

  /// Handles the registration request event
  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final userData = await _authRepository.register(
        username: event.username,
        email: event.email,
        password: event.password,
      );

      // Save user to database
      await _saveUserFromAuthData(userData);

      // State will be updated by the status stream subscription
    } catch (e) {
      emit(AuthState.error(e.toString()));
      emit(const AuthState.unauthenticated());
    }
  }

  /// Handles the logout event by calling the logOut method
  /// in the AuthRepository and disconnecting the current user
  /// in the UserRepository. Also clears all database and sync data.
  Future<void> _onLogoutPressed(
    AuthLogoutPressed event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logOut();
    await _userRepository.disconnectCurrentUser();
    // Clear all sync metadata
    await _syncRepository.clearSyncData();
    // Clear all database tables
    await _database.clearAllData();
  }

  /// Handles the token refresh request event
  Future<void> _onTokenRefreshRequested(
    AuthTokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.refreshToken();
    } catch (e) {
      // If refresh fails, user will be logged out by the repository
      addError(e);
    }
  }

  /// Tries to get the current user from the UserRepository.
  /// Returns null if there is an error or no user is found.
  Future<UserEntity?> _tryGetUser() async {
    try {
      final user = await _userRepository.getCurrentUser();
      return user;
    } catch (_) {
      return null;
    }
  }

  /// Saves user data from authentication response to the database
  Future<void> _saveUserFromAuthData(UserData userData) async {
    final user = UserEntity(
      id: userData.id,
      username: userData.username,
      email: userData.email,
      createdAt: userData.createdAt,
      updatedAt: userData.updatedAt,
    );
    await _userRepository.saveCurrentUser(user);
  }
}