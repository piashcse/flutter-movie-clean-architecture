import 'package:flutter_movie_clean_architecture/features/celebrity/domain/entities/person.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/repositories/celebrity_repository.dart';

class GetTrendingPersons {
  final CelebrityRepository repository;

  GetTrendingPersons(this.repository);

  Future<List<Person>> call(int page) async {
    return await repository.getTrendingPersons(page);
  }
}
