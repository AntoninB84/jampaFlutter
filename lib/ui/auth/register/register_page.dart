
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/ui/auth/register/register_layout.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/register/register_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(authBloc: context.read<AuthBloc>()),
      child: const RegisterLayout(),
    );
  }
}