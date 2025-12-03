import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../data/models/user/user.dart';
import '../../repository/auth_repository.dart';
import '../../repository/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// This Bloc handles the authentication state of the user.
/// It listens to the AuthRepository for changes in authentication status
/// and updates the AuthState accordingly.
///
/// It also handles logout events by calling the appropriate methods
/// in the AuthRepository and UserRepository.
///
/// For the moment, this Bloc is not used in the application.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState.unknown()) {
    on<AuthSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthLogoutPressed>(_onLogoutPressed);
  }

  final AuthRepository _authRepository = serviceLocator<AuthRepository>();
  final UserRepository _userRepository = serviceLocator<UserRepository>();

  /// Subscribes to the authentication status stream from the AuthRepository.
  Future<void> _onSubscriptionRequested(
      AuthSubscriptionRequested event,
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

  /// Handles the logout event by calling the logOut method
  /// in the AuthRepository and disconnecting the current user
  /// in the UserRepository.
  void _onLogoutPressed(AuthLogoutPressed event, Emitter<AuthState> emit) {
    _authRepository.logOut();
    _userRepository.disconnectCurrentUser();
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
}