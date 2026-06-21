import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/artist_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie_detail.dart';
import 'package:flutter_movie_clean_architecture/core/entities/credit_entity.dart';

abstract class MovieRepository {
  Future<List<Movie>> getNowPlaying(int page);
  Future<List<Movie>> getPopular(int page);
  Future<List<Movie>> getTopRated(int page);
  Future<List<Movie>> getUpComing(int page);
  Future<MovieDetail> getMovieDetail(int movieId);
  Future<List<Movie>> getMovieSearch(String query);
  Future<List<Movie>> getRecommendedMovie(int movieId);
  Future<CreditEntity> getMovieCredits(int movieId);
  Future<Artistdetail> getArtistDetail(int artistId);
  Future<CreditEntity> getArtistAllMovies(int artistId);
}