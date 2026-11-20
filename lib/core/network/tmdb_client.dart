import 'package:dio/dio.dart';
import 'package:flutter_movie_clean_architecture/core/error/app_failure.dart';

/// Thin, typed wrapper around [Dio] for the TMDB API.
///
/// Centralises response validation and error mapping so data sources stay
/// focused on endpoints.
class TmdbClient {
  const TmdbClient(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> getObject(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get<dynamic>(path, queryParameters: query);
      final data = response.data;

      if (data is Map<String, dynamic>) {
        return data;
      }
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }

      throw AppFailure(
        FailureKind.parse,
        technicalMessage: 'Expected a JSON object for "$path"',
      );
    } catch (error, stackTrace) {
      throw mapError(error, stackTrace);
    }
  }

  Future<List<T>> getList<T>(
    String path,
    T Function(Map<String, dynamic> json) fromJson, {
    Map<String, dynamic>? query,
  }) async {
    final data = await getObject(path, query: query);
    final results = data['results'];

    if (results is! List) {
      throw AppFailure(
        FailureKind.parse,
        technicalMessage: 'Missing "results" list for "$path"',
      );
    }

    return results
        .whereType<Map<dynamic, dynamic>>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }
}
