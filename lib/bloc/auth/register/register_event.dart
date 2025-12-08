part of 'register_bloc.dart';

/// Base class for all register events
sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered when username field changes
final class RegisterUsernameChanged extends RegisterEvent {
  final String username;

  const RegisterUsernameChanged(this.username);

  @override
  List<Object?> get props => [username];
}

/// Event triggered when email field changes
final class RegisterEmailChanged extends RegisterEvent {
  final String email;

  const RegisterEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

/// Event triggered when password field changes
final class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

/// Event triggered when confirm password field changes
final class RegisterConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;

  const RegisterConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

/// Event to toggle password visibility
final class RegisterPasswordVisibilityToggled extends RegisterEvent {
  const RegisterPasswordVisibilityToggled();
}

/// Event to toggle confirm password visibility
final class RegisterConfirmPasswordVisibilityToggled extends RegisterEvent {
  const RegisterConfirmPasswordVisibilityToggled();
}

/// Event triggered when form is submitted
final class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted();
}

/// Event to reset form to initial state
final class RegisterFormReset extends RegisterEvent {
  const RegisterFormReset();
}

