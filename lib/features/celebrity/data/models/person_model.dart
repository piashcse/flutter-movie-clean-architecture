import 'package:freezed_annotation/freezed_annotation.dart';

part 'person_model.freezed.dart';
part 'person_model.g.dart';

@freezed
abstract class PersonModel with _$PersonModel {
  const factory PersonModel({
    @Default(0) int id,
    @Default('') String name,
    @JsonKey(name: 'known_for_department')
    @Default('')
    String knownForDepartment,
    @Default(0) double popularity,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _PersonModel;

  factory PersonModel.fromJson(Map<String, dynamic> json) =>
      _$PersonModelFromJson(json);
}
