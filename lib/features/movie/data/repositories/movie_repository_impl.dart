import 'package:flutter_movie_clean_architecture/core/entities/credit_entity.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/models/mappers.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/artist_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  const MovieRepositoryImpl(this._remoteDataSource);

  final MovieRemoteDataSource _remoteDataSource;

  @override
  Future<List<Movie>> getNowPlaying(int page) async =>
      (await _remoteDataSource.getNowPlaying(page)).toEntities();

  @override
  Future<List<Movie>> getPopular(int page) async =>
      (await _remoteDataSource.getPopular(page)).toEntities();

  @override
  Future<List<Movie>> getTopRated(int page) async =>
      (await _remoteDataSource.getTopRated(page)).toEntities();

  @override
  Future<List<Movie>> getUpcoming(int page) async =>
      (await _remoteDataSource.getUpcoming(page)).toEntities();

  @override
  Future<MovieDetail> getMovieDetail(int movieId) async =>
      (await _remoteDataSource.getMovieDetail(movieId)).toEntity();

  @override
  Future<List<Movie>> searchMovies(String query) async =>
      (await _remoteDataSource.searchMovies(query)).toEntities();

  @override
  Future<List<Movie>> getRecommendedMovies(int movieId) async =>
      (await _remoteDataSource.getRecommendedMovies(movieId)).toEntities();

  @override
  Future<CreditEntity> getMovieCredits(int movieId) async =>
      (await _remoteDataSource.getMovieCredits(movieId)).toEntity();

  @override
  Future<ArtistDetail> getArtistDetail(int artistId) async =>
      (await _remoteDataSource.getArtistDetail(artistId)).toEntity();

  @override
  Future<CreditEntity> getArtistCredits(int artistId) async =>
      (await _remoteDataSource.getArtistCredits(artistId)).toEntity();
}
