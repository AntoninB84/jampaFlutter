import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/auth/widgets/inputs/password_field.dart';
import 'package:jampa_flutter/ui/widgets/jampa_scaffolded_app_bar_widget.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/helpers/flavors.dart';
import 'package:jampa_flutter/utils/routers/routes.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/login/login_bloc.dart';
import '../../../repository/auth_repository.dart';
import '../../../utils/constants/styles/sizes.dart';
import '../../../utils/extensions/app_context_extension.dart';
import '../../widgets/buttons/buttons.dart';
import '../../widgets/headers.dart';
import '../widgets/inputs/email_field.dart';

/// Login screen with form state managed by LoginBloc
class LoginLayout extends StatelessWidget {
  const LoginLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return JampaScaffoldedAppBarWidget(
      leading: kEmptyWidget,
      actions: [],
      body: MultiBlocListener(
        listeners: [
          // Listen to AuthBloc for authentication status
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.authenticated) {
                SnackBarX.showSuccess(context, context.strings.login_success_feedback);
                // Reset form on successful login
                context.read<LoginBloc>().add(const LoginFormReset());
              } else if (state.errorMessage != null) {
                // Get localized error message
                String errorMessage;
                if (state.errorMessage == 'login_invalid_credentials_error') {
                  errorMessage = context.strings.login_invalid_credentials_error;
                } else if (FlavorConfig.appFlavor.isProduction) {
                  errorMessage = context.strings.generic_error_message;
                } else {
                  errorMessage = state.errorMessage!;
                }
                SnackBarX.showError(context, errorMessage);
              }
            },
          ),
        ],
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, loginState) {
            // Check if AuthBloc is loading
            final authState = context.watch<AuthBloc>().state;
            final isLoading = authState.status == AuthStatus.unknown &&
                authState.errorMessage == null;

            return Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Headers.basicHeader(
                    context: context,
                    title: context.strings.login_title,
                  ),
                  const SizedBox(height: kGap16),
                  EmailField(
                    value: loginState.email.value,
                    validator: loginState.email,
                    onChanged: (value) => context.read<LoginBloc>().add(
                      LoginEmailChanged(value),
                    ),
                  ),
                  const SizedBox(height: kGap16),
                  PasswordField(
                    value: loginState.password.value,
                    isPasswordVisible: loginState.isPasswordVisible,
                    onTogglePasswordVisibility: () => context.read<LoginBloc>().add(
                      LoginPasswordVisibilityToggled(),
                    ),
                    validator: loginState.password,
                    hintText: context.strings.login_password_field_hint,
                    onChanged: (value) => context.read<LoginBloc>().add(
                      LoginPasswordChanged(value),
                    ),
                  ),
                  const SizedBox(height: kGap16),
                  Buttons.defaultButton(
                    enabled: (!isLoading && loginState.isFormValid),
                    isLoading: isLoading,
                    onPressed: () => context.read<LoginBloc>().add(
                      const LoginSubmitted(),
                    ),
                    text: context.strings.login_title,
                  ),
                  const SizedBox(height: kGap24),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () => context.pushNamed(kAppRouteRegisterName),
                    child: Text(context.strings.login_no_account_prompt),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

