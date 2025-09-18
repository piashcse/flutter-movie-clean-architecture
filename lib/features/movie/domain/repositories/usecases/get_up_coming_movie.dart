import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/entities/movie_repository.dart';

class GetUpComing {
  final MovieRepository repository;

  GetUpComing(this.repository);

  Future<List<Movie>> call(int page) => repository.getUpComing(page);
}
