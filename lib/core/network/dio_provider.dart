import 'package:dio/dio.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/localization/locale_provider.dart';
import 'package:flutter_movie_clean_architecture/core/network/debug_logging_interceptor.dart';
import 'package:flutter_movie_clean_architecture/core/network/retry_interceptor.dart';
import 'package:flutter_movie_clean_architecture/core/network/tmdb_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final locale = ref.watch(localeProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: tmdbBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {'accept': 'application/json'},
      queryParameters: {
        'api_key': tmdbApiKey,
        if (locale != null) 'language': _tmdbLanguage(locale.languageCode),
      },
    ),
  );

  dio.interceptors.addAll([RetryInterceptor(dio), DebugLoggingInterceptor()]);

  return dio;
});

final tmdbClientProvider = Provider<TmdbClient>(
  (ref) => TmdbClient(ref.watch(dioProvider)),
);

/// TMDB expects well-formed language tags such as `en-US` or `es-ES`.
String _tmdbLanguage(String languageCode) {
  final region = switch (languageCode) {
    'es' => 'ES',
    _ => 'US',
  };
  return '$languageCode-$region';
}
