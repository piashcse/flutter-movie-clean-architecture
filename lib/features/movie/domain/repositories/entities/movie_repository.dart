import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getNowPlaying();
}