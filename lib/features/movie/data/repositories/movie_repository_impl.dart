import 'package:flutter_movie_clean_architecture/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/entities/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Movie>> getNowPlaying(int page) async {
    final models = await remoteDataSource.getNowPlaying(page);
    return models
        .map((e) => Movie(
              id: e.id,
              title: e.title,
              posterPath: e.posterPath,
              overview: e.overview ?? '',
            ))
        .toList();
  }

  @override
  Future<List<Movie>> getPopular(int page) async {
    final models = await remoteDataSource.getPopular(page);
    return models
        .map((e) => Movie(
              id: e.id,
              title: e.title,
              posterPath: e.posterPath,
              overview: e.overview ?? '',
            ))
        .toList();
  }

  @override
  Future<List<Movie>> getTopRated(int page) async {
    final models = await remoteDataSource.getTopRated(page);
    return models
        .map((e) => Movie(
              id: e.id,
              title: e.title,
              posterPath: e.posterPath,
              overview: e.overview ?? '',
            ))
        .toList();
  }

  @override
  Future<List<Movie>> getUpComing(int page) async {
    final models = await remoteDataSource.getUpcoming(page);
    return models
        .map((e) => Movie(
              id: e.id,
              title: e.title,
              posterPath: e.posterPath,
              overview: e.overview ?? '',
            ))
        .toList();
  }
}
