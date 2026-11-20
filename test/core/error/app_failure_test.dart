import 'package:dio/dio.dart';
import 'package:flutter_movie_clean_architecture/core/error/app_failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

DioException _dioError({required DioExceptionType type, int? statusCode}) {
  final options = RequestOptions(path: '/movie/1');
  return DioException(
    requestOptions: options,
    type: type,
    response: statusCode == null
        ? null
        : Response<dynamic>(requestOptions: options, statusCode: statusCode),
  );
}

void main() {
  group('mapError', () {
    test('keeps an existing AppFailure', () {
      const failure = AppFailure(FailureKind.storage);
      expect(mapError(failure), same(failure));
    });

    test('maps timeouts', () {
      expect(
        mapError(_dioError(type: DioExceptionType.connectionTimeout)).kind,
        FailureKind.timeout,
      );
      expect(
        mapError(_dioError(type: DioExceptionType.receiveTimeout)).kind,
        FailureKind.timeout,
      );
    });

    test('maps connection errors to network', () {
      expect(
        mapError(_dioError(type: DioExceptionType.connectionError)).kind,
        FailureKind.network,
      );
    });

    test('maps HTTP status codes', () {
      expect(
        mapError(
          _dioError(type: DioExceptionType.badResponse, statusCode: 401),
        ).kind,
        FailureKind.unauthorized,
      );
      expect(
        mapError(
          _dioError(type: DioExceptionType.badResponse, statusCode: 404),
        ).kind,
        FailureKind.notFound,
      );
      expect(
        mapError(
          _dioError(type: DioExceptionType.badResponse, statusCode: 429),
        ).kind,
        FailureKind.rateLimit,
      );
      expect(
        mapError(
          _dioError(type: DioExceptionType.badResponse, statusCode: 503),
        ).kind,
        FailureKind.server,
      );
    });

    test('maps storage and parse failures', () {
      expect(mapError(HiveError('boom')).kind, FailureKind.storage);
      expect(mapError(const FormatException('bad')).kind, FailureKind.parse);
      expect(mapError(StateError('unexpected')).kind, FailureKind.unknown);
    });

    test('marks retryable failures', () {
      const retryable = AppFailure(FailureKind.network);
      const fatal = AppFailure(FailureKind.notFound);

      expect(retryable.isRetryable, isTrue);
      expect(fatal.isRetryable, isFalse);
    });
  });
}
