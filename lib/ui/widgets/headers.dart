import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/styles/sizes.dart';
import '../../utils/constants/styles/styles.dart';

class Headers {

  static Widget createHeader({
    required BuildContext context,
    required String title,
    required VoidCallback onAddPressed
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        IconButton(
          onPressed: onAddPressed,
          icon: const Icon(
            Icons.add,
            size: kHeadingLSize,
          ),
        ),
      ],
    );
  }

  static Widget noActionHeader({
    required BuildContext context,
    required String title,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ],
    );
  }
}