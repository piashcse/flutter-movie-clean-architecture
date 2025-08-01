import 'package:dio/dio.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/models/movie_model.dart';

class MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSource(this.dio);

  Future<List<MovieModel>> getNowPlaying(int page) async {
    final response = await dio.get('movie/now_playing', queryParameters: {'page': page});
    return (response.data['results'] as List)
        .map((e) => MovieModel.fromJson(e))
        .toList();
  }
  Future<List<MovieModel>> getPopular(int page) async {
    final response = await dio.get('movie/popular', queryParameters: {'page': page});
    return (response.data['results'] as List)
        .map((e) => MovieModel.fromJson(e))
        .toList();
  }
  Future<List<MovieModel>> getUpcoming(int page) async {
    final response = await dio.get('movie/top_rated', queryParameters: {'page': page});
    return (response.data['results'] as List)
        .map((e) => MovieModel.fromJson(e))
        .toList();
  }
  Future<List<MovieModel>> getTopRated(int page) async {
    final response = await dio.get('movie/upcoming', queryParameters: {'page': page});
    return (response.data['results'] as List)
        .map((e) => MovieModel.fromJson(e))
        .toList();
  }
}
