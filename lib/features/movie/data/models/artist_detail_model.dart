import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist_detail_model.freezed.dart';
part 'artist_detail_model.g.dart';

@freezed
class ArtistDetailModel with _$ArtistDetailModel{
  const factory ArtistDetailModel({
    required bool adult,
    @JsonKey(name: 'also_known_as') required List<String> alsoKnownAs,
    required String biography,
    String? birthday,
    String? deathday,
    required int gender,
    String? homepage,
    required int id,
    @JsonKey(name: 'imdb_id') String? imdbId,
    @JsonKey(name: 'known_for_department') required String knownForDepartment,
    required String name,
    @JsonKey(name: 'place_of_birth') String? placeOfBirth,
    required double popularity,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _ArtistDetailModel;

  factory ArtistDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ArtistDetailModelFromJson(json);
}