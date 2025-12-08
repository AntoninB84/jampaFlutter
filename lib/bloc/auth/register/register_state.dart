part of 'register_bloc.dart';

/// State for the registration form
class RegisterState extends Equatable {
  final GlobalKey formKey;
  final NameValidator username;
  final EmailValidator email;
  final PasswordValidator password;
  final PasswordValidator confirmPassword;
  final bool doPasswordsMatch;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  const RegisterState({
    this.formKey = const GlobalObjectKey('registerForm'),
    this.username = const NameValidator.pure(),
    this.email = const EmailValidator.pure(),
    this.password = const PasswordValidator.pure(),
    this.confirmPassword = const PasswordValidator.pure(),
    this.doPasswordsMatch = true,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
  });

  /// Check if form is valid and can be submitted
  bool get isFormValid =>
      username.isValid &&
      !username.isPure &&
      email.isValid &&
      !email.isPure &&
      password.isValid &&
      !password.isPure &&
      confirmPassword.isValid &&
      !confirmPassword.isPure &&
      doPasswordsMatch;

  bool get canSubmit =>
      !username.isPure &&
      !email.isPure &&
      !password.isPure &&
      !confirmPassword.isPure;

  /// Create a copy of the state with updated fields
  RegisterState copyWith({
    GlobalKey? formKey,
    NameValidator? username,
    EmailValidator? email,
    PasswordValidator? password,
    PasswordValidator? confirmPassword,
    bool? doPasswordsMatch,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return RegisterState(
      formKey: formKey ?? this.formKey,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      doPasswordsMatch: doPasswordsMatch ?? this.doPasswordsMatch,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [
        formKey,
        username,
        email,
        password,
        confirmPassword,
        doPasswordsMatch,
        isPasswordVisible,
        isConfirmPasswordVisible,
      ];
}

