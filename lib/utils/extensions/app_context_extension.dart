
import 'package:flutter/cupertino.dart';

import '../constants/l10n/app_localizations.dart';

/// Extension on BuildContext to access localized strings easily.
extension AppContext on BuildContext {
  AppLocalizations get strings => .of(this)!;
}