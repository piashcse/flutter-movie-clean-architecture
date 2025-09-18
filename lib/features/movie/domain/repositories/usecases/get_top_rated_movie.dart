import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/entities/movie_repository.dart';

class GetTopRated {
  final MovieRepository repository;

  GetTopRated(this.repository);

  Future<List<Movie>> call(int page) => repository.getTopRated(page);
}
