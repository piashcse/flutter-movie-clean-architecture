import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

/// A typed, UI-friendly failure.
///
/// Every layer funnels unexpected errors through [mapError] so the
/// presentation layer can render a translated message instead of a raw
/// exception string.
enum FailureKind {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  rateLimit,
  server,
  parse,
  storage,
  unknown,
}

class AppFailure implements Exception {
  const AppFailure(
    this.kind, {
    this.statusCode,
    this.technicalMessage,
    this.cause,
    this.stackTrace,
  });

  final FailureKind kind;
  final int? statusCode;
  final String? technicalMessage;
  final Object? cause;
  final StackTrace? stackTrace;

  bool get isRetryable => switch (kind) {
    FailureKind.network ||
    FailureKind.timeout ||
    FailureKind.rateLimit ||
    FailureKind.server => true,
    _ => false,
  };

  @override
  String toString() =>
      'AppFailure(${kind.name}'
      '${statusCode == null ? '' : ', status: $statusCode'}'
      '${technicalMessage == null ? '' : ': $technicalMessage'})';
}

/// Converts any error into an [AppFailure].
AppFailure mapError(Object error, [StackTrace? stackTrace]) {
  if (error is AppFailure) {
    return error;
  }

  if (error is DioException) {
    return _mapDioException(error, stackTrace);
  }

  if (error is HiveError) {
    return AppFailure(
      FailureKind.storage,
      technicalMessage: error.message,
      cause: error,
      stackTrace: stackTrace,
    );
  }

  if (error is FormatException || error is TypeError) {
    return AppFailure(
      FailureKind.parse,
      technicalMessage: error.toString(),
      cause: error,
      stackTrace: stackTrace,
    );
  }

  return AppFailure(
    FailureKind.unknown,
    technicalMessage: error.toString(),
    cause: error,
    stackTrace: stackTrace,
  );
}

AppFailure _mapDioException(DioException error, StackTrace? stackTrace) {
  final statusCode = error.response?.statusCode;

  final kind = switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout => FailureKind.timeout,
    DioExceptionType.connectionError => FailureKind.network,
    DioExceptionType.badCertificate => FailureKind.network,
    DioExceptionType.badResponse => _kindForStatus(statusCode),
    DioExceptionType.cancel => FailureKind.unknown,
    DioExceptionType.unknown => FailureKind.network,
  };

  return AppFailure(
    kind,
    statusCode: statusCode,
    technicalMessage: error.message ?? error.error?.toString(),
    cause: error,
    stackTrace: stackTrace,
  );
}

FailureKind _kindForStatus(int? statusCode) {
  return switch (statusCode) {
    401 => FailureKind.unauthorized,
    403 => FailureKind.forbidden,
    404 => FailureKind.notFound,
    429 => FailureKind.rateLimit,
    final code? when code >= 500 => FailureKind.server,
    _ => FailureKind.unknown,
  };
}
