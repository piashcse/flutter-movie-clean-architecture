import 'package:flutter_movie_clean_architecture/core/network/dio_provider.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:flutter_movie_clean_architecture/core/entities/credit_entity.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/artist_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/movie_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieRemoteDataSourceProvider = Provider(
  (ref) => MovieRemoteDataSource(ref.watch(dioProvider)),
);

final movieRepositoryProvider = Provider<MovieRepository>(
  (ref) => MovieRepositoryImpl(ref.watch(movieRemoteDataSourceProvider)),
);

final nowPlayingMoviesProvider =
    FutureProvider.family<List<Movie>, int>((ref, page) async {
  return ref.watch(movieRepositoryProvider).getNowPlaying(page);
});

final popularMoviesProvider =
    FutureProvider.family<List<Movie>, int>((ref, page) async {
  return ref.watch(movieRepositoryProvider).getPopular(page);
});

final topRatedMoviesProvider =
    FutureProvider.family<List<Movie>, int>((ref, page) async {
  return ref.watch(movieRepositoryProvider).getTopRated(page);
});

final upComingMoviesProvider =
    FutureProvider.family<List<Movie>, int>((ref, page) async {
  return ref.watch(movieRepositoryProvider).getUpComing(page);
});

final movieDetailProvider =
    FutureProvider.family<MovieDetail, int>((ref, movieId) async {
  return ref.watch(movieRepositoryProvider).getMovieDetail(movieId);
});

final movieSearchProvider =
    FutureProvider.family<List<Movie>, String>((ref, query) async {
  return ref.watch(movieRepositoryProvider).getMovieSearch(query);
});

final recommendMovieProvider =
    FutureProvider.family<List<Movie>, int>((ref, movieId) async {
  return ref.watch(movieRepositoryProvider).getRecommendedMovie(movieId);
});

final movieCreditsProvider =
    FutureProvider.family<CreditEntity, int>((ref, int movieId) async {
  return ref.watch(movieRepositoryProvider).getMovieCredits(movieId);
});

final artistDetailProvider =
    FutureProvider.family<Artistdetail, int>((ref, artistId) async {
  return ref.watch(movieRepositoryProvider).getArtistDetail(artistId);
});

final artistDetailAllMoviesProvider =
    FutureProvider.family((ref, int artistId) async {
  return ref.watch(movieRepositoryProvider).getArtistAllMovies(artistId);
});
