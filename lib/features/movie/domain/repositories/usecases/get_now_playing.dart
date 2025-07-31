import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/entities/movie_repository.dart';

class GetNowPlaying {
  final MovieRepository repository;

  GetNowPlaying(this.repository);

  Future<List<Movie>> call() => repository.getNowPlaying();
}