import 'package:flutter_movie_clean_architecture/features/movie/data/models/credit_model.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/entities/movie_repository.dart';

class GetMovieCredits {
  final MovieRepository repository;

  GetMovieCredits(this.repository);

  Future<Credit> call(int movieId) => repository.getMovieCredits(movieId);
}