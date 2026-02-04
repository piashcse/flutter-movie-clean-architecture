import 'package:flutter_movie_clean_architecture/core/network/dio_provider.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/artist_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_all_artist_movies.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_artist_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_movie_credits.dart'
    show GetMovieCredits;
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_movie_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_movie_search.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_now_playing_movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_popular_movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_recommended_movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_top_rated_movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_up_coming_movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data Source Provider
final movieRemoteDataSourceProvider = Provider(
  (ref) => MovieRemoteDataSource(ref.watch(dioProvider)),
);

// Repository Provider
final movieRepositoryProvider = Provider(
  (ref) => MovieRepositoryImpl(ref.watch(movieRemoteDataSourceProvider)),
);

// Use Case Providers
final getNowPlayingProvider = Provider(
  (ref) => GetNowPlaying(ref.watch(movieRepositoryProvider)),
);

final getPopularProvider = Provider(
  (ref) => GetPopular(ref.watch(movieRepositoryProvider)),
);

final getTopRatedProvider = Provider(
  (ref) => GetTopRated(ref.watch(movieRepositoryProvider)),
);

final getUpcomingProvider = Provider(
  (ref) => GetUpComing(ref.watch(movieRepositoryProvider)),
);

final getMovieDetailProvider = Provider(
  (ref) => GetMovieDetail(ref.watch(movieRepositoryProvider)),
);

final getMovieSearchProvider = Provider(
  (ref) => GetMovieSearch(ref.watch(movieRepositoryProvider)),
);

final getRecommendMovieProvider = Provider(
  (ref) => GetRecommendedMovie(ref.watch(movieRepositoryProvider)),
);

final getMovieCreditProvider = Provider(
  (ref) => GetMovieCredits(ref.watch(movieRepositoryProvider)),
);

final getArtistDetailProvider = Provider(
  (ref) => GetArtistDetail(ref.watch(movieRepositoryProvider)),
);

final getArtistAllMoviesProvider = Provider(
  (ref) => GetAllArtistMovies(ref.watch(movieRepositoryProvider)),
);

// Future Provider Families for Data Fetching
final nowPlayingMoviesProvider =
    FutureProvider.family<List<Movie>, int>((ref, page) async {
  return ref.watch(getNowPlayingProvider).call(page);
});

final popularMoviesProvider =
    FutureProvider.family<List<Movie>, int>((ref, page) async {
  return ref.watch(getPopularProvider).call(page);
});

final topRatedMoviesProvider =
    FutureProvider.family<List<Movie>, int>((ref, page) async {
  return ref.watch(getTopRatedProvider).call(page);
});

final upComingMoviesProvider =
    FutureProvider.family<List<Movie>, int>((ref, page) async {
  return ref.watch(getUpcomingProvider).call(page);
});

final movieDetailProvider =
    FutureProvider.family<MovieDetail, int>((ref, movieId) async {
  return ref.watch(getMovieDetailProvider).call(movieId);
});

final movieSearchProvider =
    FutureProvider.family<List<Movie>, String>((ref, query) async {
  return ref.watch(getMovieSearchProvider).call(query);
});

final recommendMovieProvider =
    FutureProvider.family<List<Movie>, int>((ref, movieId) async {
  return ref.watch(getRecommendMovieProvider).call(movieId);
});

final movieCreditsProvider =
    FutureProvider.family((ref, int movieId) async {
  return ref.watch(getMovieCreditProvider).call(movieId);
});

final artistDetailProvider =
    FutureProvider.family<Artistdetail, int>((ref, artistId) async {
  return ref.watch(getArtistDetailProvider).call(artistId);
});

final artistDetailAllMoviesProvider =
    FutureProvider.family((ref, int artistId) async {
  return ref.watch(getArtistAllMoviesProvider).call(artistId);
});