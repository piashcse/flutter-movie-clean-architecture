import 'package:flutter_movie_clean_architecture/core/entities/credit_entity.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/artist_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie_detail.dart';

abstract interface class MovieRepository {
  Future<List<Movie>> getNowPlaying(int page);

  Future<List<Movie>> getPopular(int page);

  Future<List<Movie>> getTopRated(int page);

  Future<List<Movie>> getUpcoming(int page);

  Future<MovieDetail> getMovieDetail(int movieId);

  Future<List<Movie>> searchMovies(String query);

  Future<List<Movie>> getRecommendedMovies(int movieId);

  Future<CreditEntity> getMovieCredits(int movieId);

  Future<ArtistDetail> getArtistDetail(int artistId);

  Future<CreditEntity> getArtistCredits(int artistId);
}
