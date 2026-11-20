import 'package:flutter/foundation.dart';

/// Single place to forward unexpected errors.
///
/// Wire a crash reporter (Crashlytics, Sentry, ...) into [report] without
/// touching the rest of the app.
abstract final class AppErrorReporter {
  static void report(Object error, StackTrace? stackTrace) {
    if (kDebugMode) {
      debugPrint('Unhandled error: $error');
      if (stackTrace != null) {
        debugPrintStack(stackTrace: stackTrace);
      }
    }
  }
}
