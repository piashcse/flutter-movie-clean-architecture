import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_detail_model.freezed.dart';
part 'movie_detail_model.g.dart';

@freezed
abstract class MovieDetailModel with _$MovieDetailModel {
  const factory MovieDetailModel({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'release_date') @Default('') String releaseDate,
    @JsonKey(name: 'vote_average') @Default(0) double voteAverage,
    @Default(0) int runtime,
    @JsonKey(name: 'original_language') @Default('') String originalLanguage,
    @Default(<Genre>[]) List<Genre> genres,
    @JsonKey(name: 'production_companies')
    @Default(<ProductionCompany>[])
    List<ProductionCompany> productionCompanies,
  }) = _MovieDetailModel;

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailModelFromJson(json);
}

@freezed
abstract class Genre with _$Genre {
  const factory Genre({@Default(0) int id, @Default('') String name}) = _Genre;

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
}

@freezed
abstract class ProductionCompany with _$ProductionCompany {
  const factory ProductionCompany({
    @Default(0) int id,
    @Default('') String name,
    @JsonKey(name: 'logo_path') String? logoPath,
  }) = _ProductionCompany;

  factory ProductionCompany.fromJson(Map<String, dynamic> json) =>
      _$ProductionCompanyFromJson(json);
}
