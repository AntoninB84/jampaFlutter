

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

/// A simple cancel button that pops the current route when pressed.
/// Optionally, you can provide an [onPressed] callback that will be executed after popping the route.
class CancelButton extends StatelessWidget {
  const CancelButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.pop();
        if(onPressed != null) onPressed!();
      },
      child: Text(context.strings.cancel),
    );
  }
}