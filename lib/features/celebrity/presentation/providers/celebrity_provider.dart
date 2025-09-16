import 'package:flutter_movie_clean_architecture/core/network/dio_provider.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/data/datasources/celebrity_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/data/repositories/celebrity_repository_impl.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/entities/person.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/usecases/get_popular_persons.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/usecases/get_trending_persons.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/usecases/search_persons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final celebrityRemoteDataSourceProvider = Provider(
  (ref) => CelebrityRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final celebrityRepositoryProvider = Provider(
  (ref) => CelebrityRepositoryImpl(ref.watch(celebrityRemoteDataSourceProvider)),
);

final getPopularPersonsProvider = Provider(
  (ref) => GetPopularPersons(ref.watch(celebrityRepositoryProvider)),
);

final popularPersonsProvider =
    FutureProvider.family<List<Person>, int>((ref, page) async {
  return ref.watch(getPopularPersonsProvider).call(page);
});

final getTrendingPersonsProvider = Provider(
  (ref) => GetTrendingPersons(ref.watch(celebrityRepositoryProvider)),
);

final trendingPersonsProvider =
    FutureProvider.family<List<Person>, int>((ref, page) async {
  return ref.watch(getTrendingPersonsProvider).call(page);
});

final searchPersonsProvider = Provider(
  (ref) => SearchPersons(ref.watch(celebrityRepositoryProvider)),
);

final searchPersonsResultProvider =
    FutureProvider.family<List<Person>, String>((ref, query) async {
  return ref.watch(searchPersonsProvider).call(query, 1);
});

final searchPersonsPaginatedProvider =
    FutureProvider.family<List<Person>, (String, int)>((ref, params) async {
  final (query, page) = params;
  return ref.watch(searchPersonsProvider).call(query, page);
});