import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/styles/sizes.dart';

/// A collection of common UI components and styles used across the app.
abstract class Commons {

  /// A container widget for secondary lists with specific styling, such as
  /// maximum height, border, and padding.
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