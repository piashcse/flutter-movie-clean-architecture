import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_model.freezed.dart';
part 'credit_model.g.dart';

@freezed
class CreditModel with _$CreditModel {
  const factory CreditModel({
    required int id,
    List<Cast>? cast,
    List<Crew>? crew,
  }) = _CreditModel;

  factory CreditModel.fromJson(Map<String, dynamic> json) => _$CreditModelFromJson(json);
}

@freezed
class Cast with _$Cast {
  const factory Cast({
    required int id,
    bool? adult,
    int? gender,
    @JsonKey(name: 'known_for_department') String? knownForDepartment,
    String? name,
    @JsonKey(name: 'original_name') String? originalName,
    double? popularity,
    @JsonKey(name: 'profile_path') String? profilePath,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'cast_id') int? castId,
    String? character,
    @JsonKey(name: 'credit_id') String? creditId,
    int? order,
    @JsonKey(name: 'media_type') String? mediaType,
    @JsonKey(name: 'first_air_date') String? firstAirDate,
  }) = _Cast;

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);
}

@freezed
class Crew with _$Crew {
  const factory Crew({
    required int id,
    bool? adult,
    int? gender,
    @JsonKey(name: 'known_for_department') String? knownForDepartment,
    String? name,
    @JsonKey(name: 'original_name') String? originalName,
    double? popularity,
    @JsonKey(name: 'profile_path') String? profilePath,
    @JsonKey(name: 'credit_id') String? creditId,
    String? department,
    String? job,
  }) = _Crew;

  factory Crew.fromJson(Map<String, dynamic> json) => _$CrewFromJson(json);
}