import 'package:flutter_movie_clean_architecture/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/models/credit_model.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/artist_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/repositories/entities/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Movie>> getNowPlaying(int page) async {
    final models = await remoteDataSource.getNowPlaying(page);
    return models
        .map(
          (e) => Movie(
            id: e.id,
            title: e.title,
            posterPath: e.posterPath,
            overview: e.overview ?? '',
          ),
        )
        .toList();
  }

  @override
  Future<List<Movie>> getPopular(int page) async {
    final models = await remoteDataSource.getPopular(page);
    return models
        .map(
          (e) => Movie(
            id: e.id,
            title: e.title,
            posterPath: e.posterPath,
            overview: e.overview ?? '',
          ),
        )
        .toList();
  }

  @override
  Future<List<Movie>> getTopRated(int page) async {
    final models = await remoteDataSource.getTopRated(page);
    return models
        .map(
          (e) => Movie(
            id: e.id,
            title: e.title,
            posterPath: e.posterPath,
            overview: e.overview ?? '',
          ),
        )
        .toList();
  }

  @override
  Future<List<Movie>> getUpComing(int page) async {
    final models = await remoteDataSource.getUpcoming(page);
    return models
        .map(
          (e) => Movie(
            id: e.id,
            title: e.title,
            posterPath: e.posterPath,
            overview: e.overview ?? '',
          ),
        )
        .toList();
  }

  @override
  Future<MovieDetail> getMovieDetail(int movieId) async {
    final model = await remoteDataSource.getMovieDetail(movieId);

    return MovieDetail(
      id: model.id,
      title: model.title,
      overview: model.overview,
      posterPath: model.posterPath ?? "",
      releaseDate: model.releaseDate ?? "",
      voteAverage: model.voteAverage ?? 0,
      runtime: model.runtime ?? 0,
      originalLanguage: model.originalLanguage ?? "N/A",
      genres: model.genres?.map((genre) => genre.name ?? "").toList() ?? [],
      productionCompanies:
          model.productionCompanies
              ?.map((company) => company.name ?? "")
              .toList() ??
          [],
    );
  }

  @override
  Future<List<Movie>> getMovieSearch(String query) async {
    final models = await remoteDataSource.getMovieSearch(query);
    return models
        .map(
          (e) => Movie(
            id: e.id,
            title: e.title,
            posterPath: e.posterPath,
            overview: e.overview ?? '',
          ),
        )
        .toList();
  }

  @override
  Future<List<Movie>> getRecommendedMovie(int movieId) async {
    final models = await remoteDataSource.getRecommendedMovie(movieId);
    return models
        .map(
          (e) => Movie(
            id: e.id,
            title: e.title,
            posterPath: e.posterPath,
            overview: e.overview ?? '',
          ),
        )
        .toList();
  }

  @override
  Future<CreditModel> getMovieCredits(int movieId) async {
    final model = await remoteDataSource.getMovieCredits(movieId);
    return CreditModel(id: model.id, cast: model.cast, crew: model.crew);
  }

  @override
  Future<Artistdetail> getArtistDetail(int artistId) async {
    final model = await remoteDataSource.getArtistDetail(artistId);
    return Artistdetail(
      id: model.id,
      name: model.name,
      profilePath: model.profilePath,
      biography: model.biography,
      knownForDepartment: model.knownForDepartment,
      placeOfBirth: model.placeOfBirth ?? '',
      birthday: model.birthday ?? '',
    );
  }

  Future<CreditModel> getArtistAllMovies(int artistId) async {
    final model = await remoteDataSource.getArtistAllMovies(artistId);
    return CreditModel(id: model.id, cast: model.cast, crew: model.crew);
  }
}
