import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/credit_entity.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/movie_repository.dart';

class GetMovieCredits {
  final MovieRepository repository;

  GetMovieCredits(this.repository);

  Future<CreditEntity> call(int movieId) => repository.getMovieCredits(movieId);
}