part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

/// Event to request subscription to authentication status changes.
/// This event triggers the Bloc to start listening to the
/// authentication status stream from the AuthRepository.
final class AuthVerificationRequested extends AuthEvent {}

/// Event to handle user login.
final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });
}

/// Event to handle user registration.
final class AuthRegisterRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const AuthRegisterRequested({
    required this.username,
    required this.email,
    required this.password,
  });
}

/// Event to handle user logout.
/// This event triggers the Bloc to call the logout methods
/// in the AuthRepository and UserRepository.
final class AuthLogoutPressed extends AuthEvent {}

/// Event to handle token refresh.
final class AuthTokenRefreshRequested extends AuthEvent {}
