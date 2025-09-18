import 'package:freezed_annotation/freezed_annotation.dart';

part 'person_model.freezed.dart';
part 'person_model.g.dart';

@freezed
class PersonModel with _$PersonModel {
  const factory PersonModel({
    required bool adult,
    @JsonKey(name: 'gender') required int gender,
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'known_for_department') required String knownForDepartment,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'popularity') required double popularity,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _PersonModel;

  factory PersonModel.fromJson(Map<String, dynamic> json) =>
      _$PersonModelFromJson(json);
}
