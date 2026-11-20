import 'package:flutter_movie_clean_architecture/core/network/dio_provider.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/data/datasources/celebrity_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/data/repositories/celebrity_repository_impl.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/entities/person.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/repositories/celebrity_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final celebrityRemoteDataSourceProvider = Provider<CelebrityRemoteDataSource>(
  (ref) => CelebrityRemoteDataSourceImpl(ref.watch(tmdbClientProvider)),
);

final celebrityRepositoryProvider = Provider<CelebrityRepository>(
  (ref) =>
      CelebrityRepositoryImpl(ref.watch(celebrityRemoteDataSourceProvider)),
);

final popularPersonsProvider = FutureProvider.autoDispose
    .family<List<Person>, int>((ref, page) async {
      return ref.watch(celebrityRepositoryProvider).getPopularPersons(page);
    });

final trendingPersonsProvider = FutureProvider.autoDispose
    .family<List<Person>, int>((ref, page) async {
      return ref.watch(celebrityRepositoryProvider).getTrendingPersons(page);
    });

final searchPersonsProvider = FutureProvider.autoDispose
    .family<List<Person>, String>((ref, query) async {
      return ref.watch(celebrityRepositoryProvider).searchPersons(query, 1);
    });
