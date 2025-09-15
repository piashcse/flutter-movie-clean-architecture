import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_series_credit_model.freezed.dart';
part 'tv_series_credit_model.g.dart';

@freezed
class TvSeriesCreditModel with _$TvSeriesCreditModel {
  const factory TvSeriesCreditModel({
    required int id,
    List<Cast>? cast,
    List<Crew>? crew,
  }) = _TvSeriesCreditModel;

  factory TvSeriesCreditModel.fromJson(Map<String, dynamic> json) => _$TvSeriesCreditModelFromJson(json);
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