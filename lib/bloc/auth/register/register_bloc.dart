import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/bloc/auth/auth_bloc.dart';
import 'package:jampa_flutter/utils/forms/email_validator.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';
import 'package:jampa_flutter/utils/forms/password_validator.dart';

part 'register_event.dart';
part 'register_state.dart';

/// BLoC to handle registration form state and validation
///
/// This BLoC manages the registration form UI state (username, email, passwords, validation)
/// while delegating actual authentication to AuthBloc.
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthBloc _authBloc;

  RegisterBloc({required AuthBloc authBloc})
      : _authBloc = authBloc,
        super(const RegisterState()) {
    on<RegisterUsernameChanged>(_onUsernameChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<RegisterPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<RegisterConfirmPasswordVisibilityToggled>(_onConfirmPasswordVisibilityToggled);
    on<RegisterSubmitted>(_onSubmitted);
    on<RegisterFormReset>(_onFormReset);
  }

  /// Handle username field changes
  void _onUsernameChanged(RegisterUsernameChanged event, Emitter<RegisterState> emit) {
    final username = NameValidator.dirty(event.username.trim());
    emit(state.copyWith(username: username));
  }

  /// Handle email field changes
  void _onEmailChanged(RegisterEmailChanged event, Emitter<RegisterState> emit) {
    final email = EmailValidator.dirty(event.email.trim());
    emit(state.copyWith(email: email));
  }

  /// Handle password field changes
  void _onPasswordChanged(RegisterPasswordChanged event, Emitter<RegisterState> emit) {
    final password = PasswordValidator.dirty(event.password);

    // Check if passwords match when password changes
    final doPasswordsMatch = password.value == state.confirmPassword.value;

    emit(state.copyWith(
      password: password,
      doPasswordsMatch: state.confirmPassword.isPure ? true : doPasswordsMatch,
    ));
  }

  /// Handle confirm password field changes
  void _onConfirmPasswordChanged(
    RegisterConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final confirmPassword = PasswordValidator.dirty(event.confirmPassword);
    final doPasswordsMatch = confirmPassword.value == state.password.value;

    emit(state.copyWith(
      confirmPassword: confirmPassword,
      doPasswordsMatch: doPasswordsMatch,
    ));
  }

  /// Toggle password visibility
  void _onPasswordVisibilityToggled(
    RegisterPasswordVisibilityToggled event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  /// Toggle confirm password visibility
  void _onConfirmPasswordVisibilityToggled(
    RegisterConfirmPasswordVisibilityToggled event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible));
  }

  /// Handle form submission
  void _onSubmitted(RegisterSubmitted event, Emitter<RegisterState> emit) {
    // Validate all fields
    final username = NameValidator.dirty(state.username.value);
    final email = EmailValidator.dirty(state.email.value);
    final password = PasswordValidator.dirty(state.password.value);
    final confirmPassword = PasswordValidator.dirty(state.confirmPassword.value);
    final doPasswordsMatch = state.password.value == state.confirmPassword.value;

    Formz.validate([
      username,
      email,
      password,
      confirmPassword,
    ]);

    emit(state.copyWith(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      doPasswordsMatch: doPasswordsMatch,
    ));

    if (!state.isFormValid) {
      return;
    }

    // Delegate to AuthBloc for actual registration
    _authBloc.add(AuthRegisterRequested(
      username: state.username.value,
      email: state.email.value,
      password: state.password.value,
    ));
  }

  /// Reset form to initial state
  void _onFormReset(RegisterFormReset event, Emitter<RegisterState> emit) {
    emit(const RegisterState());
  }
}

