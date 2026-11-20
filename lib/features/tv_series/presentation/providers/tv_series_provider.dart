import 'package:flutter_movie_clean_architecture/core/entities/credit_entity.dart';
import 'package:flutter_movie_clean_architecture/core/network/dio_provider.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/data/datasources/tv_series_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/data/repositories/tv_series_repository_impl.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/repositories/tv_series_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tvSeriesRemoteDataSourceProvider = Provider<TvSeriesRemoteDataSource>(
  (ref) => TvSeriesRemoteDataSourceImpl(ref.watch(tmdbClientProvider)),
);

final tvSeriesRepositoryProvider = Provider<TvSeriesRepository>(
  (ref) => TvSeriesRepositoryImpl(ref.watch(tvSeriesRemoteDataSourceProvider)),
);

final airingTodayTvSeriesProvider = FutureProvider.autoDispose
    .family<List<TvSeries>, int>((ref, page) async {
      return ref.watch(tvSeriesRepositoryProvider).getAiringToday(page);
    });

final onTheAirTvSeriesProvider = FutureProvider.autoDispose
    .family<List<TvSeries>, int>((ref, page) async {
      return ref.watch(tvSeriesRepositoryProvider).getOnTheAir(page);
    });

final popularTvSeriesProvider = FutureProvider.autoDispose
    .family<List<TvSeries>, int>((ref, page) async {
      return ref.watch(tvSeriesRepositoryProvider).getPopular(page);
    });

final upcomingTvSeriesProvider = FutureProvider.autoDispose
    .family<List<TvSeries>, int>((ref, page) async {
      return ref.watch(tvSeriesRepositoryProvider).getUpcoming(page);
    });

final tvSeriesDetailProvider = FutureProvider.autoDispose
    .family<TvSeriesDetail, int>((ref, tvSeriesId) async {
      return ref
          .watch(tvSeriesRepositoryProvider)
          .getTvSeriesDetail(tvSeriesId);
    });

final tvSeriesSearchProvider = FutureProvider.autoDispose
    .family<List<TvSeries>, String>((ref, query) async {
      return ref.watch(tvSeriesRepositoryProvider).searchTvSeries(query);
    });

final recommendedTvSeriesProvider = FutureProvider.autoDispose
    .family<List<TvSeries>, int>((ref, tvSeriesId) async {
      return ref
          .watch(tvSeriesRepositoryProvider)
          .getRecommendedTvSeries(tvSeriesId);
    });

final tvSeriesCreditsProvider = FutureProvider.autoDispose
    .family<CreditEntity, int>((ref, tvSeriesId) async {
      return ref
          .watch(tvSeriesRepositoryProvider)
          .getTvSeriesCredits(tvSeriesId);
    });
