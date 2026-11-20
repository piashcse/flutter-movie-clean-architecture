import '../../../../core/entities/credit_entity.dart';
import '../../../../core/models/credit_model.dart';
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
    genres: [
      for (final genre in genres)
        if (genre.name.isNotEmpty) genre.name,
    ],
    productionCompanies: [
      for (final company in productionCompanies)
        if (company.name.isNotEmpty) company.name,
    ],
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

extension CreditModelMapper on CreditModel {
  CreditEntity toEntity() => CreditEntity(
    id: id,
    cast: cast.map((member) => member.toEntity()).toList(growable: false),
    crew: crew.map((member) => member.toEntity()).toList(growable: false),
  );
}

extension CastModelMapper on CastModel {
  CastMember toEntity() => CastMember(
    id: id,
    name: name,
    character: character,
    profilePath: profilePath,
    posterPath: posterPath,
    castId: castId,
    order: order,
    mediaType: mediaType,
  );
}

extension CrewModelMapper on CrewModel {
  CrewMember toEntity() => CrewMember(
    id: id,
    name: name,
    profilePath: profilePath,
    job: job,
    department: department,
  );
}
