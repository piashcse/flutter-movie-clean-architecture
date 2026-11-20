import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist_detail_model.freezed.dart';
part 'artist_detail_model.g.dart';

@freezed
abstract class ArtistDetailModel with _$ArtistDetailModel {
  const factory ArtistDetailModel({
    @Default(0) int id,
    @Default('') String name,
    String? biography,
    @JsonKey(name: 'known_for_department')
    @Default('')
    String knownForDepartment,
    @JsonKey(name: 'place_of_birth') String? placeOfBirth,
    String? birthday,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _ArtistDetailModel;

  factory ArtistDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ArtistDetailModelFromJson(json);
}
