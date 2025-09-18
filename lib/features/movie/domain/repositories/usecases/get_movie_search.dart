import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/entities/movie_repository.dart';

class GetMovieSearch {
  final MovieRepository repository;

  GetMovieSearch(this.repository);

  Future<List<Movie>> call(String query) => repository.getMovieSearch(query);
}
