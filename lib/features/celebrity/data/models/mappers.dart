import '../../domain/entities/person.dart';
import 'person_model.dart';

extension PersonModelMapper on PersonModel {
  Person toEntity() => Person(id: id, name: name, profilePath: profilePath);
}

extension PersonModelListMapper on List<PersonModel> {
  List<Person> toEntities() =>
      map((model) => model.toEntity()).toList(growable: false);
}
