import 'package:flutter_movie_clean_architecture/features/tv_series/data/datasources/tv_series_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/data/models/tv_series_detail_model.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/data/models/tv_series_model.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/repositories/entities/tv_series_repository.dart';

class TvSeriesRepositoryImpl implements TvSeriesRepository {
  final TvSeriesRemoteDataSource remoteDataSource;

  TvSeriesRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<TvSeries>> getAiringToday(int page) async {
    final models = await remoteDataSource.getAiringToday(page);
    return models
        .map((e) => TvSeries(
              id: e.id,
              name: e.name,
              posterPath: e.posterPath,
              overview: e.overview,
            ))
        .toList();
  }

  @override
  Future<List<TvSeries>> getOnTheAir(int page) async {
    final models = await remoteDataSource.getOnTheAir(page);
    return models
        .map((e) => TvSeries(
              id: e.id,
              name: e.name,
              posterPath: e.posterPath,
              overview: e.overview,
            ))
        .toList();
  }

  @override
  Future<List<TvSeries>> getPopular(int page) async {
    final models = await remoteDataSource.getPopular(page);
    return models
        .map((e) => TvSeries(
              id: e.id,
              name: e.name,
              posterPath: e.posterPath,
              overview: e.overview,
            ))
        .toList();
  }

  @override
  Future<List<TvSeries>> getUpcoming(int page) async {
    final models = await remoteDataSource.getUpcoming(page);
    return models
        .map((e) => TvSeries(
              id: e.id,
              name: e.name,
              posterPath: e.posterPath,
              overview: e.overview,
            ))
        .toList();
  }

  @override
  Future<TvSeriesDetail> getTvSeriesDetail(int tvSeriesId) async {
    final model = await remoteDataSource.getTvSeriesDetail(tvSeriesId);
    return TvSeriesDetail(
      id: model.id,
      name: model.name,
      posterPath: model.posterPath,
      overview: model.overview,
      voteAverage: model.voteAverage,
      firstAirDate: model.firstAirDate,
      originalLanguage: model.originalLanguage,
      episodeRunTime: model.episodeRunTime,
      lastAirDate: model.lastAirDate,
      numberOfEpisodes: model.numberOfEpisodes,
      numberOfSeasons: model.numberOfSeasons,
    );
  }

  @override
  Future<List<TvSeries>> searchTvSeries(String query) async {
    final models = await remoteDataSource.searchTvSeries(query);
    return models
        .map((e) => TvSeries(
              id: e.id,
              name: e.name,
              posterPath: e.posterPath,
              overview: e.overview,
            ))
        .toList();
  }
}