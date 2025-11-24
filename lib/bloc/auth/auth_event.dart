part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

/// Event to request subscription to authentication status changes.
/// This event triggers the Bloc to start listening to the
/// authentication status stream from the AuthRepository.
final class AuthSubscriptionRequested extends AuthEvent {}

/// Event to handle user logout.
/// This event triggers the Bloc to call the logout methods
/// in the AuthRepository and UserRepository.
final class AuthLogoutPressed extends AuthEvent {}