
import 'package:flutter/cupertino.dart';

import '../constants/l10n/app_localizations.dart';

extension AppContext on BuildContext {
  AppLocalizations get strings => AppLocalizations.of(this)!;
}