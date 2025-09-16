import 'package:flutter_movie_clean_architecture/features/celebrity/domain/entities/person.dart';

abstract class CelebrityRepository {
  Future<List<Person>> getPopularPersons(int page);
  Future<List<Person>> getTrendingPersons(int page);
  Future<List<Person>> searchPersons(String query, int page);
}