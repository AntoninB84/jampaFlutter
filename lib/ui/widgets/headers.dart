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
            style: kHeading1,
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
}