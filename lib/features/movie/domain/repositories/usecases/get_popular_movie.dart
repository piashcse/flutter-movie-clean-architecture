import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/entities/movie_repository.dart';

class GetPopular {
  final MovieRepository repository;

  GetPopular(this.repository);

  Future<List<Movie>> call(int page) => repository.getPopular(page);
}
