part of 'login_bloc.dart';

/// Base class for all login events
sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered when email field changes
final class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

/// Event triggered when password field changes
final class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

/// Event to toggle password visibility
final class LoginPasswordVisibilityToggled extends LoginEvent {
  const LoginPasswordVisibilityToggled();
}

/// Event triggered when form is submitted
final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

/// Event to reset form to initial state
final class LoginFormReset extends LoginEvent {
  const LoginFormReset();
}

