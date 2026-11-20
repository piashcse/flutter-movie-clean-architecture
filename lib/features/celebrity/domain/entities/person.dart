import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';

@freezed
abstract class Person with _$Person {
  const factory Person({
    required int id,
    @Default('') String name,
    String? profilePath,
  }) = _Person;
}
