import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/repositories/entities/tv_series_repository.dart';

class GetTvSeriesSearch {
  final TvSeriesRepository repository;

  GetTvSeriesSearch(this.repository);

  Future<List<TvSeries>> call(String query) async {
    return await repository.searchTvSeries(query);
  }
}