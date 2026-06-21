import 'package:flutter_movie_clean_architecture/core/entities/credit_entity.dart' as credit_entity;
import 'package:flutter_movie_clean_architecture/features/tv_series/data/datasources/tv_series_remote_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/data/models/tv_series_credit_model.dart' as credit_model;
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/repositories/tv_series_repository.dart';


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

  @override
  Future<List<TvSeries>> getRecommendedTvSeries(int tvSeriesId) async {
    final models = await remoteDataSource.getRecommendedTvSeries(tvSeriesId);
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
  Future<credit_entity.CreditEntity> getTvSeriesCredits(int tvSeriesId) async {
    final model = await remoteDataSource.getTvSeriesCredits(tvSeriesId);
    return credit_entity.CreditEntity(
      id: model.id,
      cast: model.cast?.map((cast) => credit_entity.Cast(
        id: cast.id ?? 0,
        character: cast.character,
        name: cast.name,
        profilePath: cast.profilePath,
        castId: cast.castId,
        order: cast.order,
      )).toList() ?? [],
      crew: model.crew?.map((crew) => credit_entity.Crew(
        id: crew.id ?? 0,
        name: crew.name,
        profilePath: crew.profilePath,
        job: crew.job,
        department: crew.department,
      )).toList() ?? [],
    );
  }
}