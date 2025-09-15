import 'package:flutter_movie_clean_architecture/features/tv_series/data/models/tv_series_detail_model.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series_detail.dart';

abstract class TvSeriesRepository {
  Future<List<TvSeries>> getAiringToday(int page);
  Future<List<TvSeries>> getOnTheAir(int page);
  Future<List<TvSeries>> getPopular(int page);
  Future<List<TvSeries>> getUpcoming(int page);
  Future<TvSeriesDetail> getTvSeriesDetail(int tvSeriesId);
  Future<List<TvSeries>> searchTvSeries(String query);
}