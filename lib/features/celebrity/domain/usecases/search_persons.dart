import 'package:flutter_movie_clean_architecture/features/celebrity/domain/entities/person.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/repositories/celebrity_repository.dart';

class SearchPersons {
  final CelebrityRepository repository;

  SearchPersons(this.repository);

  Future<List<Person>> call(String query, int page) async {
    return await repository.searchPersons(query, page);
  }
}
