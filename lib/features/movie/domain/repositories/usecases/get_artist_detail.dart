import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/ArtistDetail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/entities/movie_repository.dart';

class GetArtistDetail {
  final MovieRepository repository;

  GetArtistDetail(this.repository);

  Future<Artistdetail> call(int artistId) =>
      repository.getArtistDetail(artistId);
}
