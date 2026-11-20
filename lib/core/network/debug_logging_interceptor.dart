import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Minimal, privacy-safe request logger.
///
/// Only active in debug builds and never prints query parameters (the TMDB key
/// is sent there) nor request/response bodies.
class DebugLoggingInterceptor extends Interceptor {
  static const String _startedAtKey = 'debug_started_at';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      options.extra[_startedAtKey] = DateTime.now();
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _log(response.requestOptions, status: response.statusCode, success: true);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log(
      err.requestOptions,
      status: err.response?.statusCode,
      success: false,
      error: err.type.name,
    );
    handler.next(err);
  }

  void _log(
    RequestOptions options, {
    required bool success,
    int? status,
    String? error,
  }) {
    if (!kDebugMode) {
      return;
    }

    final startedAt = options.extra[_startedAtKey];
    final elapsed = startedAt is DateTime
        ? ' (${DateTime.now().difference(startedAt).inMilliseconds}ms)'
        : '';

    // `options.path` excludes the query string, so the API key is never logged.
    final outcome = success ? '${status ?? '-'}' : 'failed: ${error ?? '-'}';
    debugPrint('HTTP ${options.method} ${options.path} → $outcome$elapsed');
  }
}
