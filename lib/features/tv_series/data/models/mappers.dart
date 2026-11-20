import '../../domain/entities/tv_series.dart';
import '../../domain/entities/tv_series_detail.dart';
import 'tv_series_detail_model.dart';
import 'tv_series_model.dart';

extension TvSeriesModelMapper on TvSeriesModel {
  TvSeries toEntity() =>
      TvSeries(id: id, name: name, posterPath: posterPath, overview: overview);
}

extension TvSeriesModelListMapper on List<TvSeriesModel> {
  List<TvSeries> toEntities() =>
      map((model) => model.toEntity()).toList(growable: false);
}

extension TvSeriesDetailModelMapper on TvSeriesDetailModel {
  TvSeriesDetail toEntity() => TvSeriesDetail(
    id: id,
    name: name,
    posterPath: posterPath,
    overview: overview,
    voteAverage: voteAverage,
    firstAirDate: firstAirDate,
    originalLanguage: originalLanguage,
    episodeRunTime: episodeRunTime,
    numberOfEpisodes: numberOfEpisodes,
    numberOfSeasons: numberOfSeasons,
  );
}
