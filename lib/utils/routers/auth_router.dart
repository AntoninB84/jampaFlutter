import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/auth/login/login_page.dart';

import '../../ui/auth/register/register_page.dart';

class AuthRoutes {
  static const String login = '/login';
  static const String register = '/register';
}

/// A router for authentication-related routes.
///
/// Handles navigation between login and register screens
/// when the user is not authenticated.
final GoRouter authRouter = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: AuthRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AuthRoutes.register,
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
  ],
);