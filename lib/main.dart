import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_config.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/error/app_error_reporter.dart';
import 'package:flutter_movie_clean_architecture/core/hive/hive_helper.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/core/localization/locale_provider.dart';
import 'package:flutter_movie_clean_architecture/core/theme/app_theme.dart';
import 'package:flutter_movie_clean_architecture/core/theme/theme_providers.dart';
import 'package:flutter_movie_clean_architecture/routing/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  await runZonedGuarded(_bootstrap, AppErrorReporter.report);
}

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    AppErrorReporter.report(details.exception, details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    AppErrorReporter.report(error, stackTrace);
    return true;
  };

  await Future.wait([AppConfig.load(), HiveHelper.init()]);

  if (!hasTmdbApiKey) {
    debugPrint(
      'TMDB_API_KEY is not set. Add it to assets/config/env.json '
      '(copy assets/config/env.example.json) or pass '
      '--dart-define=TMDB_API_KEY=your_key.',
    );
  }

  await HiveHelper.init();

  runApp(
    ProviderScope(
      // Riverpod 3 retries failed providers (up to 10 times) by default, which
      // keeps `.future` pending and makes screens look stuck on a spinner.
      // Transient network errors are already retried by RetryInterceptor.
      retry: (retryCount, error) => null,
      child: const MyApp(),
    ),
  );
}

/// Disables Riverpod's provider-level retry.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!hasTmdbApiKey) {
      return const _MissingConfigurationApp();
    }

    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeModeProvider),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => context.l10n.appTitle,
    );
  }
}

/// Shown instead of the router when no TMDB key was injected, so the app never
/// spins forever on unauthorised requests.
class _MissingConfigurationApp extends ConsumerWidget {
  const _MissingConfigurationApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeModeProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => context.l10n.appTitle,
      home: Builder(
        builder: (context) {
          final colors = Theme.of(context).colorScheme;

          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.key_off, size: 64, color: colors.error),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.errorMissingApiKey,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
