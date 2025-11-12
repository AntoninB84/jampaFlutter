import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/styles/sizes.dart';

abstract class Commons {
  static Widget secondaryListsContainer({
    required BuildContext context,
    required Widget child
  }) {
    return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.3,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 0.2,
          ),
          borderRadius: BorderRadius.vertical(
              top: Radius.zero,
              bottom: Radius.circular(4.0)
          ),
        ),
        padding: const EdgeInsets.all(kGap8),
        child: child,
    );
  }
}