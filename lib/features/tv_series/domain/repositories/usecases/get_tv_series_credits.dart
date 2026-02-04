import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series_credit_entity.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/repositories/tv_series_repository.dart';

class GetTvSeriesCredits {
  final TvSeriesRepository repository;

  GetTvSeriesCredits(this.repository);

  Future<TvSeriesCreditEntity> call(int tvSeriesId) => repository.getTvSeriesCredits(tvSeriesId);
}