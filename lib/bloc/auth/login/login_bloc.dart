import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jampa_flutter/bloc/auth/auth_bloc.dart';
import 'package:jampa_flutter/utils/forms/email_validator.dart';
import 'package:jampa_flutter/utils/forms/password_validator.dart';

part 'login_event.dart';
part 'login_state.dart';

/// BLoC to handle login form state and validation
///
/// This BLoC manages the login form UI state (email, password, validation)
/// while delegating actual authentication to AuthBloc.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc _authBloc;

  LoginBloc({required AuthBloc authBloc})
      : _authBloc = authBloc,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginFormReset>(_onFormReset);
  }

  /// Handle email field changes
  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = EmailValidator.dirty(event.email.trim());
    emit(state.copyWith(email: email));
  }

  /// Handle password field changes
  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    final password = PasswordValidator.dirty(event.password);
    emit(state.copyWith(password: password));
  }

  /// Toggle password visibility
  void _onPasswordVisibilityToggled(
    LoginPasswordVisibilityToggled event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  /// Handle form submission
  void _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) {
    // Validate all fields
    final email = EmailValidator.dirty(state.email.value);
    final password = PasswordValidator.dirty(state.password.value);

    emit(state.copyWith(
      email: email,
      password: password,
    ));

    if (!state.isFormValid) {
      return;
    }

    // Delegate to AuthBloc for actual authentication
    _authBloc.add(AuthLoginRequested(
      email: state.email.value,
      password: state.password.value,
    ));
  }

  /// Reset form to initial state
  void _onFormReset(LoginFormReset event, Emitter<LoginState> emit) {
    emit(const LoginState());
  }
}

