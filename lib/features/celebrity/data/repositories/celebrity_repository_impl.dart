import 'package:flutter_movie_clean_architecture/features/celebrity/data/datasources/celebrity_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/data/models/person_model.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/entities/person.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/repositories/celebrity_repository.dart';

class CelebrityRepositoryImpl implements CelebrityRepository {
  final CelebrityRemoteDataSource remoteDataSource;

  CelebrityRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Person>> getPopularPersons(int page) async {
    final models = await remoteDataSource.getPopularPersons(page);
    return _mapToEntities(models.results);
  }

  @override
  Future<List<Person>> getTrendingPersons(int page) async {
    final models = await remoteDataSource.getTrendingPersons(page);
    return _mapToEntities(models.results);
  }

  @override
  Future<List<Person>> searchPersons(String query, int page) async {
    final models = await remoteDataSource.searchPersons(query, page);
    return _mapToEntities(models.results);
  }

  List<Person> _mapToEntities(List<PersonModel> models) {
    return models
        .map((model) => Person(
              id: model.id,
              name: model.name,
              profilePath: model.profilePath,
              knownForDepartment: model.knownForDepartment,
              popularity: model.popularity,
            ))
        .toList();
  }
}