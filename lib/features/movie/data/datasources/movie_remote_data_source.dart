import 'package:flutter_movie_clean_architecture/core/models/credit_model.dart';
import 'package:flutter_movie_clean_architecture/core/network/tmdb_client.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/models/artist_detail_model.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/models/movie_detail_model.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/models/movie_model.dart';

abstract interface class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlaying(int page);

  Future<List<MovieModel>> getPopular(int page);

  Future<List<MovieModel>> getTopRated(int page);

  Future<List<MovieModel>> getUpcoming(int page);

  Future<MovieDetailModel> getMovieDetail(int movieId);

  Future<List<MovieModel>> searchMovies(String query);

  Future<List<MovieModel>> getRecommendedMovies(int movieId);

  Future<CreditModel> getMovieCredits(int movieId);

  Future<ArtistDetailModel> getArtistDetail(int artistId);

  Future<CreditModel> getArtistCredits(int artistId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  const MovieRemoteDataSourceImpl(this._client);

  final TmdbClient _client;

  static const _pageKey = 'page';

  @override
  Future<List<MovieModel>> getNowPlaying(int page) => _client.getList(
    'movie/now_playing',
    MovieModel.fromJson,
    query: {_pageKey: page},
  );

  @override
  Future<List<MovieModel>> getPopular(int page) => _client.getList(
    'movie/popular',
    MovieModel.fromJson,
    query: {_pageKey: page},
  );

  @override
  Future<List<MovieModel>> getTopRated(int page) => _client.getList(
    'movie/top_rated',
    MovieModel.fromJson,
    query: {_pageKey: page},
  );

  @override
  Future<List<MovieModel>> getUpcoming(int page) => _client.getList(
    'movie/upcoming',
    MovieModel.fromJson,
    query: {_pageKey: page},
  );

  @override
  Future<MovieDetailModel> getMovieDetail(int movieId) async =>
      MovieDetailModel.fromJson(await _client.getObject('movie/$movieId'));

  @override
  Future<List<MovieModel>> searchMovies(String query) => _client.getList(
    'search/movie',
    MovieModel.fromJson,
    query: {'query': query},
  );

  @override
  Future<List<MovieModel>> getRecommendedMovies(int movieId) =>
      _client.getList('movie/$movieId/recommendations', MovieModel.fromJson);

  @override
  Future<CreditModel> getMovieCredits(int movieId) async =>
      CreditModel.fromJson(await _client.getObject('movie/$movieId/credits'));

  @override
  Future<ArtistDetailModel> getArtistDetail(int artistId) async =>
      ArtistDetailModel.fromJson(await _client.getObject('person/$artistId'));

  @override
  Future<CreditModel> getArtistCredits(int artistId) async =>
      CreditModel.fromJson(
        await _client.getObject('person/$artistId/combined_credits'),
      );
}
