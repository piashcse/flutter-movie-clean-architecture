import 'package:flutter_movie_clean_architecture/core/network/dio_provider.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/usecases/get_now_playing.dart';
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