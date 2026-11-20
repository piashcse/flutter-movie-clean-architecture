import 'package:flutter_movie_clean_architecture/core/config/app_config.dart';

const String tmdbBaseUrl = 'https://api.themoviedb.org/3/';
const String _tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';

/// The TMDB API key supplied via `--dart-define` or `assets/config/env.json`.
String get tmdbApiKey => AppConfig.tmdbApiKey;

bool get hasTmdbApiKey => AppConfig.hasTmdbApiKey;

/// Builds an absolute TMDB image URL for [path].
///
/// Returns `null` when [path] is missing so widgets can render a placeholder.
String? tmdbImage(String? path, {String size = 'w342'}) {
  if (path == null || path.isEmpty) {
    return null;
  }
  return '$_tmdbImageBaseUrl/$size/$path';
}
