import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/repositories/entities/tv_series_repository.dart';

class GetTvSeriesDetail {
  final TvSeriesRepository repository;

  GetTvSeriesDetail(this.repository);

  Future<TvSeriesDetail> call(int tvSeriesId) => repository.getTvSeriesDetail(tvSeriesId);
}