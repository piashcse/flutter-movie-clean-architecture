import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/credit_entity.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/movie_repository.dart';

class GetAllArtistMovies {
  final MovieRepository repository;

  GetAllArtistMovies(this.repository);

  Future<CreditEntity> call(int artistId) => repository.getArtistAllMovies(artistId);
}