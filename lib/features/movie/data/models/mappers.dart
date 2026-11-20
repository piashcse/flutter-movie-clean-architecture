import '../../domain/entities/artist_detail.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import 'artist_detail_model.dart';
import 'movie_detail_model.dart';
import 'movie_model.dart';

extension MovieModelMapper on MovieModel {
  Movie toEntity() =>
      Movie(id: id, title: title, posterPath: posterPath, overview: overview);
}

extension MovieModelListMapper on List<MovieModel> {
  List<Movie> toEntities() =>
      map((model) => model.toEntity()).toList(growable: false);
}

extension MovieDetailModelMapper on MovieDetailModel {
  MovieDetail toEntity() => MovieDetail(
    id: id,
    title: title,
    overview: overview,
    posterPath: posterPath,
    releaseDate: releaseDate,
    voteAverage: voteAverage,
    runtime: runtime,
    originalLanguage: originalLanguage,
  );
}

extension ArtistDetailModelMapper on ArtistDetailModel {
  ArtistDetail toEntity() => ArtistDetail(
    id: id,
    name: name,
    profilePath: profilePath,
    biography: biography ?? '',
    knownForDepartment: knownForDepartment,
    placeOfBirth: placeOfBirth ?? '',
    birthday: birthday ?? '',
  );
}
