import 'package:flutter_movie_clean_architecture/core/entities/credit_entity.dart';
import 'package:flutter_movie_clean_architecture/core/network/dio_provider.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/artist_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/movie_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieRemoteDataSourceProvider = Provider<MovieRemoteDataSource>(
  (ref) => MovieRemoteDataSourceImpl(ref.watch(tmdbClientProvider)),
);

final movieRepositoryProvider = Provider<MovieRepository>(
  (ref) => MovieRepositoryImpl(ref.watch(movieRemoteDataSourceProvider)),
);

// Paginated listings are cached per page; they are cheap immutable results and
// keeping them avoids re-fetching when scrolling back.

final nowPlayingMoviesProvider = FutureProvider.family<List<Movie>, int>((
  ref,
  page,
) async {
  return ref.watch(movieRepositoryProvider).getNowPlaying(page);
});

final popularMoviesProvider = FutureProvider.family<List<Movie>, int>((
  ref,
  page,
) async {
  return ref.watch(movieRepositoryProvider).getPopular(page);
});

final topRatedMoviesProvider = FutureProvider.family<List<Movie>, int>((
  ref,
  page,
) async {
  return ref.watch(movieRepositoryProvider).getTopRated(page);
});

final upcomingMoviesProvider = FutureProvider.family<List<Movie>, int>((
  ref,
  page,
) async {
  return ref.watch(movieRepositoryProvider).getUpcoming(page);
});

// Detail and search providers are auto-disposed so leaving a screen or
// changing the query releases the result immediately.

final movieDetailProvider = FutureProvider.autoDispose.family<MovieDetail, int>(
  (ref, movieId) async {
    return ref.watch(movieRepositoryProvider).getMovieDetail(movieId);
  },
);

final movieSearchProvider = FutureProvider.autoDispose
    .family<List<Movie>, String>((ref, query) async {
      return ref.watch(movieRepositoryProvider).searchMovies(query);
    });

final recommendedMoviesProvider = FutureProvider.autoDispose
    .family<List<Movie>, int>((ref, movieId) async {
      return ref.watch(movieRepositoryProvider).getRecommendedMovies(movieId);
    });

final movieCreditsProvider = FutureProvider.autoDispose
    .family<CreditEntity, int>((ref, movieId) async {
      return ref.watch(movieRepositoryProvider).getMovieCredits(movieId);
    });

final artistDetailProvider = FutureProvider.autoDispose
    .family<ArtistDetail, int>((ref, artistId) async {
      return ref.watch(movieRepositoryProvider).getArtistDetail(artistId);
    });

final artistCreditsProvider = FutureProvider.autoDispose
    .family<CreditEntity, int>((ref, artistId) async {
      return ref.watch(movieRepositoryProvider).getArtistCredits(artistId);
    });
