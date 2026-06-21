import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:flutter_movie_clean_architecture/core/entities/credit_entity.dart';

abstract class TvSeriesRepository {
  Future<List<TvSeries>> getAiringToday(int page);
  Future<List<TvSeries>> getOnTheAir(int page);
  Future<List<TvSeries>> getPopular(int page);
  Future<List<TvSeries>> getUpcoming(int page);
  Future<TvSeriesDetail> getTvSeriesDetail(int tvSeriesId);
  Future<List<TvSeries>> searchTvSeries(String query);
  Future<List<TvSeries>> getRecommendedTvSeries(int tvSeriesId);
  Future<CreditEntity> getTvSeriesCredits(int tvSeriesId);
}