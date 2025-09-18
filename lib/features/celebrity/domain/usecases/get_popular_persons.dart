import 'package:flutter_movie_clean_architecture/features/celebrity/domain/entities/person.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/repositories/celebrity_repository.dart';

class GetPopularPersons {
  final CelebrityRepository repository;

  GetPopularPersons(this.repository);

  Future<List<Person>> call(int page) async {
    return await repository.getPopularPersons(page);
  }
}
