import 'package:dio/dio.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/models/movie_detail_model.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/models/movie_model.dart';

class MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSource(this.dio);

  Future<List<MovieModel>> getNowPlaying(int page) async {
    final response =
        await dio.get('movie/now_playing', queryParameters: {'page': page});
    return (response.data['results'] as List)
        .map((e) => MovieModel.fromJson(e))
        .toList();
  }

  Future<List<MovieModel>> getPopular(int page) async {
    final response =
        await dio.get('movie/popular', queryParameters: {'page': page});
    return (response.data['results'] as List)
        .map((e) => MovieModel.fromJson(e))
        .toList();
  }

  Future<List<MovieModel>> getUpcoming(int page) async {
    final response =
        await dio.get('movie/top_rated', queryParameters: {'page': page});
    return (response.data['results'] as List)
        .map((e) => MovieModel.fromJson(e))
        .toList();
  }

  Future<List<MovieModel>> getTopRated(int page) async {
    final response =
        await dio.get('movie/upcoming', queryParameters: {'page': page});
    return (response.data['results'] as List)
        .map((e) => MovieModel.fromJson(e))
        .toList();
  }

  Future<MovieDetailModel> getMovieDetail(int id) async {
    final response = await dio.get('/movie/$id');
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data is Map<String, dynamic>) {
      return MovieDetailModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load movie detail: Invalid response');
    }
  }

  Future<List<MovieModel>> getMovieSearch(String query) async {
    final response =
        await dio.get('/search/movie', queryParameters: {'query': query});
    return (response.data['results'] as List)
        .map((e) => MovieModel.fromJson(e))
        .toList();
  }
}
