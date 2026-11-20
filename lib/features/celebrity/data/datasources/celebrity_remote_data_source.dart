import 'package:flutter_movie_clean_architecture/core/network/tmdb_client.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/data/models/person_model.dart';

abstract interface class CelebrityRemoteDataSource {
  Future<List<PersonModel>> getPopularPersons(int page);

  Future<List<PersonModel>> getTrendingPersons(int page);

  Future<List<PersonModel>> searchPersons(String query, int page);
}

class CelebrityRemoteDataSourceImpl implements CelebrityRemoteDataSource {
  const CelebrityRemoteDataSourceImpl(this._client);

  final TmdbClient _client;

  static const _pageKey = 'page';

  @override
  Future<List<PersonModel>> getPopularPersons(int page) => _client.getList(
    'person/popular',
    PersonModel.fromJson,
    query: {_pageKey: page},
  );

  @override
  Future<List<PersonModel>> getTrendingPersons(int page) => _client.getList(
    'trending/person/week',
    PersonModel.fromJson,
    query: {_pageKey: page},
  );

  @override
  Future<List<PersonModel>> searchPersons(String query, int page) =>
      _client.getList(
        'search/person',
        PersonModel.fromJson,
        query: {'query': query, _pageKey: page},
      );
}
