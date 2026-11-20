import 'package:flutter_movie_clean_architecture/core/entities/credit_entity.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/data/datasources/tv_series_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/data/models/mappers.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/repositories/tv_series_repository.dart';

class TvSeriesRepositoryImpl implements TvSeriesRepository {
  const TvSeriesRepositoryImpl(this._remoteDataSource);

  final TvSeriesRemoteDataSource _remoteDataSource;

  @override
  Future<List<TvSeries>> getAiringToday(int page) async =>
      (await _remoteDataSource.getAiringToday(page)).toEntities();

  @override
  Future<List<TvSeries>> getOnTheAir(int page) async =>
      (await _remoteDataSource.getOnTheAir(page)).toEntities();

  @override
  Future<List<TvSeries>> getPopular(int page) async =>
      (await _remoteDataSource.getPopular(page)).toEntities();

  @override
  Future<List<TvSeries>> getUpcoming(int page) async =>
      (await _remoteDataSource.getUpcoming(page)).toEntities();

  @override
  Future<TvSeriesDetail> getTvSeriesDetail(int tvSeriesId) async =>
      (await _remoteDataSource.getDetail(tvSeriesId)).toEntity();

  @override
  Future<List<TvSeries>> searchTvSeries(String query) async =>
      (await _remoteDataSource.search(query)).toEntities();

  @override
  Future<List<TvSeries>> getRecommendedTvSeries(int tvSeriesId) async =>
      (await _remoteDataSource.getRecommended(tvSeriesId)).toEntities();

  @override
  Future<CreditEntity> getTvSeriesCredits(int tvSeriesId) async =>
      (await _remoteDataSource.getCredits(tvSeriesId)).toTvCreditEntity();
}
