import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';

@freezed
abstract class Person with _$Person {
  const factory Person({
    required int id,
    @Default('') String name,
    String? profilePath,
    @Default('') String knownForDepartment,
    @Default(0) double popularity,
  }) = _Person;
}
