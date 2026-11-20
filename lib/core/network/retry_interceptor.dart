import 'package:dio/dio.dart';

/// Retries idempotent GET requests a couple of times on transient failures
/// (timeouts, connection errors, HTTP 429 and 5xx).
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio, {this.maxAttempts = 2});

  final Dio _dio;
  final int maxAttempts;

  static const String _attemptKey = 'retry_attempt';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = (err.requestOptions.extra[_attemptKey] as int?) ?? 1;

    if (!_shouldRetry(err) || attempt >= maxAttempts) {
      handler.next(err);
      return;
    }

    final delay = Duration(milliseconds: 300 * attempt);
    await Future<void>.delayed(delay);

    final options = err.requestOptions
      ..extra[_attemptKey] = attempt + 1
      ..extra.remove(Headers.contentLengthHeader);

    try {
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _shouldRetry(DioException err) {
    if (err.requestOptions.method.toUpperCase() != 'GET') {
      return false;
    }

    final status = err.response?.statusCode;
    return switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => true,
      DioExceptionType.badResponse => status == 429 || (status ?? 0) >= 500,
      _ => false,
    };
  }
}
