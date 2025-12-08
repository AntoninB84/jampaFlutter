part of 'login_bloc.dart';

/// State for the login form
class LoginState extends Equatable {
  final EmailValidator email;
  final PasswordValidator password;
  final bool isPasswordVisible;

  const LoginState({
    this.email = const EmailValidator.pure(),
    this.password = const PasswordValidator.pure(),
    this.isPasswordVisible = false,
  });

  /// Check if form is valid and can be submitted
  bool get isFormValid =>
      email.isValid &&
      !email.isPure &&
      password.isValid &&
      !password.isPure;

  /// Create a copy of the state with updated fields
  LoginState copyWith({
    EmailValidator? email,
    PasswordValidator? password,
    bool? isPasswordVisible,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        isPasswordVisible,
      ];
}

