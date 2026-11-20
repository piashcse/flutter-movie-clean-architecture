import 'package:flutter/widgets.dart';
import 'package:flutter_movie_clean_architecture/l10n/app_localizations.dart';

export 'package:flutter_movie_clean_architecture/l10n/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
