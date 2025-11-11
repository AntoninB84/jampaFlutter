import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/styles/sizes.dart';
import '../../utils/constants/styles/styles.dart';

class Headers {

  static Widget listHeader({
    required BuildContext context,
    required String title,
    required VoidCallback onAddPressed,
    VoidCallback? onBackPressed
  }) {
    return Row(
      children: [
        if(onBackPressed != null)
          IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onBackPressed,
              icon: const Icon(Icons.arrow_back)
          ),
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

  static Widget basicHeader({
    required BuildContext context,
    required String title,
    required VoidCallback onBackPressed
  }) {
    return Row(
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: onBackPressed,
          icon: const Icon(Icons.arrow_back)
        ),
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