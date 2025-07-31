import 'package:flutter_movie_clean_architecture/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/entities/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Movie>> getNowPlaying() async {
    final models = await remoteDataSource.getNowPlaying();
    return models.map((e) => Movie(
      id: e.id,
      title: e.title,
      posterPath: e.posterPath,
      overview: e.overview ?? '',
    )).toList();
  }
}