
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/ui/auth/login/login_layout.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/login/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(authBloc: context.read<AuthBloc>()),
      child: const LoginLayout(),
    );
  }
}