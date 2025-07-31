import 'package:dio/dio.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/models/movie_model.dart';

class MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSource(this.dio);

  Future<List<MovieModel>> getNowPlaying() async {
    final response = await dio.get('movie/now_playing');
    return (response.data['results'] as List)
        .map((e) => MovieModel.fromJson(e))
        .toList();
  }
}
