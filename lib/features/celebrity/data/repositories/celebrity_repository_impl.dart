import 'package:flutter_movie_clean_architecture/features/celebrity/data/datasources/celebrity_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/data/models/mappers.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/entities/person.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/repositories/celebrity_repository.dart';

class CelebrityRepositoryImpl implements CelebrityRepository {
  const CelebrityRepositoryImpl(this._remoteDataSource);

  final CelebrityRemoteDataSource _remoteDataSource;

  @override
  Future<List<Person>> getPopularPersons(int page) async =>
      (await _remoteDataSource.getPopularPersons(page)).toEntities();

  @override
  Future<List<Person>> getTrendingPersons(int page) async =>
      (await _remoteDataSource.getTrendingPersons(page)).toEntities();

  @override
  Future<List<Person>> searchPersons(String query, int page) async =>
      (await _remoteDataSource.searchPersons(query, page)).toEntities();
}
