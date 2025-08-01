import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_detail_model.freezed.dart';
part 'movie_detail_model.g.dart';

@freezed
class MovieDetailModel with _$MovieDetailModel {
  const factory MovieDetailModel({
    required int id,
    required String title,
    required String overview,
    @JsonKey(name: 'poster_path') required String posterPath,
    @JsonKey(name: 'release_date') required String releaseDate,
    @JsonKey(name: 'vote_average') required double voteAverage,
    required int runtime,
    @JsonKey(name: 'original_language') String? originalLanguage,
    List<Genre>? genres,
    @JsonKey(name: 'production_companies') List<ProductionCompany>? productionCompanies,
  }) = _MovieDetailModel;

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailModelFromJson(json);
}

@freezed
class Genre with _$Genre {
  const factory Genre({
    required int id,
    required String? name,
  }) = _Genre;

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
}

@freezed
class ProductionCompany with _$ProductionCompany {
  const factory ProductionCompany({
    required int id,
    String? name,
    @JsonKey(name: 'logo_path') String? logoPath,
  }) = _ProductionCompany;

  factory ProductionCompany.fromJson(Map<String, dynamic> json) =>
      _$ProductionCompanyFromJson(json);
}