import 'package:flutter_movie_clean_architecture/core/network/dio_provider.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_movie_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_movie_search.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_now_playing.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_popular.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_top_rated.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_up_coming.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieRemoteDataSourceProvider = Provider(
      (ref) => MovieRemoteDataSource(ref.watch(dioProvider)),
);

final movieRepositoryProvider = Provider(
      (ref) => MovieRepositoryImpl(ref.watch(movieRemoteDataSourceProvider)),
);

final getNowPlayingProvider = Provider(
      (ref) => GetNowPlaying(ref.watch(movieRepositoryProvider)),
);

final nowPlayingMoviesProvider = FutureProvider.family<List<Movie>, int>((ref, page) async {
  return ref.watch(getNowPlayingProvider).call(page);
});

final getPopularProvider = Provider(
      (ref) => GetPopular(ref.watch(movieRepositoryProvider)),
);

final popularMoviesProvider = FutureProvider.family<List<Movie>, int>((ref, page) async {
  return ref.watch(getPopularProvider).call(page);
});

final getTopRatedProvider = Provider(
      (ref) => GetTopRated(ref.watch(movieRepositoryProvider)),
);

final topRatedMoviesProvider = FutureProvider.family<List<Movie>, int>((ref, page) async {
  return ref.watch(getTopRatedProvider).call(page);
});

final getUpcomingProvider = Provider(
      (ref) => GetUpComing(ref.watch(movieRepositoryProvider)),
);

final upComingMoviesProvider = FutureProvider.family<List<Movie>, int>((ref, page) async {
  return ref.watch(getUpcomingProvider).call(page);
});

final getMovieDetailProvider = Provider(
      (ref) => GetMovieDetail(ref.watch(movieRepositoryProvider)),
);

final movieDetailProvider = FutureProvider.family<MovieDetail, int>((ref, movieId) async {
  return ref.watch(getMovieDetailProvider).call(movieId);
});

final getMovieSearchProvider = Provider(
      (ref) => GetMovieSearch(ref.watch(movieRepositoryProvider)),
);

final movieSearchProvider = FutureProvider.family<List<Movie>, String>((ref, query) async {
  return ref.watch(getMovieSearchProvider).call(query);
});