import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_movie_clean_architecture/core/network/dio_provider.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/data/models/person_list_response.dart';

abstract class CelebrityRemoteDataSource {
  Future<PersonListResponse> getPopularPersons(int page);
  Future<PersonListResponse> getTrendingPersons(int page);
  Future<PersonListResponse> searchPersons(String query, int page);
}

class CelebrityRemoteDataSourceImpl implements CelebrityRemoteDataSource {
  final Dio dio;

  CelebrityRemoteDataSourceImpl(this.dio);

  @override
  Future<PersonListResponse> getPopularPersons(int page) async {
    final response = await dio.get(
      'person/popular',
      queryParameters: {'page': page},
    );
    return PersonListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PersonListResponse> getTrendingPersons(int page) async {
    final response = await dio.get(
      'trending/person/week',
      queryParameters: {'page': page},
    );
    return PersonListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PersonListResponse> searchPersons(String query, int page) async {
    final response = await dio.get(
      'search/person',
      queryParameters: {
        'query': query,
        'page': page,
      },
    );
    return PersonListResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

final celebrityRemoteDataSourceProvider = Provider<CelebrityRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return CelebrityRemoteDataSourceImpl(dio);
});