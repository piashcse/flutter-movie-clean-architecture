import 'package:dio/dio.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/data/models/tv_series_credit_model.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/data/models/tv_series_detail_model.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/data/models/tv_series_model.dart';

class TvSeriesRemoteDataSource {
  final Dio dio;

  TvSeriesRemoteDataSource(this.dio);

  Future<List<TvSeriesModel>> getAiringToday(int page) async {
    final response = await dio.get(
      'tv/airing_today',
      queryParameters: {'page': page},
    );
    return (response.data['results'] as List)
        .map((e) => TvSeriesModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<TvSeriesModel>> getOnTheAir(int page) async {
    final response = await dio.get(
      'tv/on_the_air',
      queryParameters: {'page': page},
    );
    return (response.data['results'] as List)
        .map((e) => TvSeriesModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<TvSeriesModel>> getPopular(int page) async {
    final response = await dio.get(
      'tv/popular',
      queryParameters: {'page': page},
    );
    return (response.data['results'] as List)
        .map((e) => TvSeriesModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<TvSeriesModel>> getUpcoming(int page) async {
    final response = await dio.get(
      'tv/upcoming',
      queryParameters: {'page': page},
    );
    return (response.data['results'] as List)
        .map((e) => TvSeriesModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<TvSeriesDetailModel> getTvSeriesDetail(int id) async {
    final response = await dio.get('/tv/$id');
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data is Map<String, dynamic>) {
      return TvSeriesDetailModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } else {
      throw Exception('Failed to load TV series detail: Invalid response');
    }
  }

  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    final response = await dio.get(
      'search/tv',
      queryParameters: {'query': query},
    );
    return (response.data['results'] as List)
        .map((e) => TvSeriesModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<TvSeriesModel>> getRecommendedTvSeries(int tvSeriesId) async {
    final response = await dio.get('tv/$tvSeriesId/recommendations');
    return (response.data['results'] as List)
        .map((e) => TvSeriesModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<TvSeriesCreditModel> getTvSeriesCredits(int tvSeriesId) async {
    final response = await dio.get('tv/$tvSeriesId/credits');
    return TvSeriesCreditModel.fromJson(response.data as Map<String, dynamic>);
  }
}
