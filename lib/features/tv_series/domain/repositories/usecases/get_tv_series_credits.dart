import 'package:flutter_movie_clean_architecture/features/tv_series/data/models/tv_series_credit_model.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/repositories/entities/tv_series_repository.dart';

class GetTvSeriesCredits {
  final TvSeriesRepository repository;

  GetTvSeriesCredits(this.repository);

  Future<TvSeriesCreditModel> call(int tvSeriesId) => repository.getTvSeriesCredits(tvSeriesId);
}