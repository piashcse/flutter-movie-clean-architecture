import 'package:flutter_movie_clean_architecture/core/network/dio_provider.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/data/datasources/tv_series_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/data/repositories/tv_series_repository_impl.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/repositories/usecases/get_airing_today.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/repositories/usecases/get_on_the_air.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/repositories/usecases/get_popular_tv_series.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/repositories/usecases/get_tv_series_detail.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/repositories/usecases/get_tv_series_search.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/repositories/usecases/get_upcoming_tv_series.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tvSeriesRemoteDataSourceProvider = Provider(
  (ref) => TvSeriesRemoteDataSource(ref.watch(dioProvider)),
);

final tvSeriesRepositoryProvider = Provider(
  (ref) => TvSeriesRepositoryImpl(ref.watch(tvSeriesRemoteDataSourceProvider)),
);

final getAiringTodayProvider = Provider(
  (ref) => GetAiringToday(ref.watch(tvSeriesRepositoryProvider)),
);

final airingTodayTvSeriesProvider =
    FutureProvider.family<List<TvSeries>, int>((ref, page) async {
  return ref.watch(getAiringTodayProvider).call(page);
});

final getOnTheAirProvider = Provider(
  (ref) => GetOnTheAir(ref.watch(tvSeriesRepositoryProvider)),
);

final onTheAirTvSeriesProvider =
    FutureProvider.family<List<TvSeries>, int>((ref, page) async {
  return ref.watch(getOnTheAirProvider).call(page);
});

final getPopularTvSeriesProvider = Provider(
  (ref) => GetPopularTvSeries(ref.watch(tvSeriesRepositoryProvider)),
);

final popularTvSeriesProvider =
    FutureProvider.family<List<TvSeries>, int>((ref, page) async {
  return ref.watch(getPopularTvSeriesProvider).call(page);
});

final getUpcomingTvSeriesProvider = Provider(
  (ref) => GetUpcomingTvSeries(ref.watch(tvSeriesRepositoryProvider)),
);

final upcomingTvSeriesProvider =
    FutureProvider.family<List<TvSeries>, int>((ref, page) async {
  return ref.watch(getUpcomingTvSeriesProvider).call(page);
});

final getTvSeriesDetailProvider = Provider(
  (ref) => GetTvSeriesDetail(ref.watch(tvSeriesRepositoryProvider)),
);

final tvSeriesDetailProvider =
    FutureProvider.family<TvSeriesDetail, int>((ref, tvSeriesId) async {
  return ref.watch(getTvSeriesDetailProvider).call(tvSeriesId);
});

final getTvSeriesSearchProvider = Provider(
  (ref) => GetTvSeriesSearch(ref.watch(tvSeriesRepositoryProvider)),
);

final tvSeriesSearchProvider =
    FutureProvider.family<List<TvSeries>, String>((ref, query) async {
  return ref.watch(getTvSeriesSearchProvider).call(query);
});