import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_model.freezed.dart';
part 'credit_model.g.dart';

/// Shared credits payload used by both movies and TV series.
@freezed
abstract class CreditModel with _$CreditModel {
  const factory CreditModel({
    @Default(0) int id,
    @Default(<CastModel>[]) List<CastModel> cast,
    @Default(<CrewModel>[]) List<CrewModel> crew,
  }) = _CreditModel;

  factory CreditModel.fromJson(Map<String, dynamic> json) =>
      _$CreditModelFromJson(json);
}

@freezed
abstract class CastModel with _$CastModel {
  const factory CastModel({
    @Default(0) int id,
    @Default('') String name,
    String? character,
    @JsonKey(name: 'profile_path') String? profilePath,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'cast_id') int? castId,
    int? order,
    @JsonKey(name: 'media_type') String? mediaType,
  }) = _CastModel;

  factory CastModel.fromJson(Map<String, dynamic> json) =>
      _$CastModelFromJson(json);
}

@freezed
abstract class CrewModel with _$CrewModel {
  const factory CrewModel({
    @Default(0) int id,
    @Default('') String name,
    @JsonKey(name: 'profile_path') String? profilePath,
    String? job,
    String? department,
  }) = _CrewModel;

  factory CrewModel.fromJson(Map<String, dynamic> json) =>
      _$CrewModelFromJson(json);
}
