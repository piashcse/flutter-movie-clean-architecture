import 'package:flutter_movie_clean_architecture/features/movie/data/models/credit_model.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/entities/movie_repository.dart';

class GetAllArtistMovies {
  final MovieRepository repository;

  GetAllArtistMovies(this.repository);

  Future<CreditModel> call(int artistId) => repository.getArtistAllMovies(artistId);
}