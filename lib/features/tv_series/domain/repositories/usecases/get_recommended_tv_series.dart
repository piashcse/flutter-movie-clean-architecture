import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/repositories/entities/tv_series_repository.dart';

class GetRecommendedTvSeries {
  final TvSeriesRepository repository;

  GetRecommendedTvSeries(this.repository);

  Future<List<TvSeries>> call(int tvSeriesId) =>
      repository.getRecommendedTvSeries(tvSeriesId);
}
