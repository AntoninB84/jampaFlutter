import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/ui/auth/widgets/inputs/email_field.dart';
import 'package:jampa_flutter/ui/auth/widgets/inputs/password_field.dart';
import 'package:jampa_flutter/ui/auth/widgets/inputs/username_field.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';
import 'package:jampa_flutter/ui/widgets/jampa_scaffolded_app_bar_widget.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/register/register_bloc.dart';
import '../../../repository/auth_repository.dart';
import '../../../utils/extensions/app_context_extension.dart';
import '../../../utils/helpers/flavors.dart';
import '../../widgets/headers.dart';

/// Registration screen with form state managed by RegisterBloc
class RegisterLayout extends StatelessWidget {
  const RegisterLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return JampaScaffoldedAppBarWidget(
      leading: null,
      actions: [],
      body: MultiBlocListener(
        listeners: [
          // Listen to AuthBloc for authentication status
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.authenticated) {
                SnackBarX.showSuccess(context, context.strings.signup_success_feedback);
                // Reset form on successful registration
                context.read<RegisterBloc>().add(const RegisterFormReset());
              } else if (state.errorMessage != null) {
                FlavorConfig.appFlavor.isProduction ?
                SnackBarX.showError(context, context.strings.generic_error_message) :
                SnackBarX.showError(context, state.errorMessage!);
              }
            },
          ),
        ],
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, registerState) {
            // Check if AuthBloc is loading
            final authState = context.watch<AuthBloc>().state;
            final isLoading = authState.status == AuthStatus.unknown &&
                             authState.errorMessage == null;

            return Form(
              key: registerState.formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Headers.basicHeader(
                      context: context,
                      title: context.strings.signup_title,
                    ),
                    const SizedBox(height: kGap16),
                    UsernameField(
                      value: registerState.username.value,
                      validator: registerState.username,
                      onChanged: (value) => context.read<RegisterBloc>().add(
                            RegisterUsernameChanged(value),
                          ),
                    ),
                    const SizedBox(height: kGap16),
                    EmailField(
                      value: registerState.email.value,
                      validator: registerState.email,
                      onChanged: (value) => context.read<RegisterBloc>().add(
                            RegisterEmailChanged(value),
                          ),
                    ),
                    const SizedBox(height: kGap16),
                    PasswordField(
                      value: registerState.password.value,
                      isPasswordVisible: registerState.isPasswordVisible,
                      onTogglePasswordVisibility: () => context.read<RegisterBloc>().add(
                        RegisterPasswordVisibilityToggled(),
                      ),
                      validator: registerState.password,
                      hintText: context.strings.signup_password_field_hint,
                      onChanged: (value) => context.read<RegisterBloc>().add(
                            RegisterPasswordChanged(value),
                          ),
                    ),
                    const SizedBox(height: kGap16),
                    PasswordField(
                      value: registerState.confirmPassword.value,
                      isPasswordVisible: registerState.isConfirmPasswordVisible,
                      onTogglePasswordVisibility: () => context.read<RegisterBloc>().add(
                        RegisterConfirmPasswordVisibilityToggled(),
                      ),
                      passwordsMatch: registerState.doPasswordsMatch,
                      validator: registerState.confirmPassword,
                      hintText: context.strings.signup_confirm_password_field_hint,
                      onChanged: (value) => context.read<RegisterBloc>().add(
                            RegisterConfirmPasswordChanged(value),
                          ),
                    ),
                    const SizedBox(height: kGap24),
                    Buttons.defaultButton(
                      enabled: !isLoading && registerState.canSubmit,
                      isLoading: isLoading,
                      onPressed: () => context.read<RegisterBloc>().add(
                        const RegisterSubmitted(),
                      ),
                      text: context.strings.signup_title,
                    ),
                    const SizedBox(height: kGap16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

