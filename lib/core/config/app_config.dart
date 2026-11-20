import 'dart:convert';

import 'package:flutter/services.dart';

/// Resolves runtime configuration.
///
/// The API key can be supplied in two ways:
///
/// 1. At build time (recommended for CI):
///    `--dart-define=TMDB_API_KEY=...`
///    or `--dart-define-from-file=assets/config/env.json`
/// 2. By placing `assets/config/env.json` next to this project. The file is
///    bundled as an asset and read at startup, so IDEs and plain
///    `flutter run` work without extra arguments. It is git-ignored.
class AppConfig {
  static const String assetPath = 'assets/config/env.json';

  static const String _defineKey = String.fromEnvironment('TMDB_API_KEY');

  static String _apiKey = _defineKey;

  static String get tmdbApiKey => _apiKey;

  static bool get hasTmdbApiKey => _apiKey.isNotEmpty;

  static Future<void> load() async {
    if (_apiKey.isNotEmpty) {
      // Build-time value wins; no need to read the optional asset.
      return;
    }

    try {
      final contents = await rootBundle.loadString(assetPath);
      final decoded = jsonDecode(contents);
      if (decoded is Map) {
        final value = decoded['TMDB_API_KEY'];
        if (value is String) {
          final key = value.trim();
          // Ignore the example placeholder so we don't make doomed requests.
          if (key.isNotEmpty && !key.startsWith('your_')) {
            _apiKey = key;
          }
        }
      }
    } on Object {
      // The asset is optional. The UI shows a configuration message when the
      // key is still missing.
    }
  }
}
