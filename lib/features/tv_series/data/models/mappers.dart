import '../../../../core/entities/credit_entity.dart';
import '../../../../core/models/credit_model.dart';
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
    lastAirDate: lastAirDate,
    numberOfEpisodes: numberOfEpisodes,
    numberOfSeasons: numberOfSeasons,
  );
}

extension TvCreditMapper on CreditModel {
  CreditEntity toTvCreditEntity() => CreditEntity(
    id: id,
    cast: cast.map((member) => member.toEntity()).toList(growable: false),
    crew: crew.map((member) => member.toEntity()).toList(growable: false),
  );
}

extension TvCastModelMapper on CastModel {
  CastMember toEntity() => CastMember(
    id: id,
    name: name,
    character: character,
    profilePath: profilePath,
    posterPath: posterPath,
    castId: castId,
    order: order,
    mediaType: mediaType,
  );
}

extension TvCrewModelMapper on CrewModel {
  CrewMember toEntity() => CrewMember(
    id: id,
    name: name,
    profilePath: profilePath,
    job: job,
    department: department,
  );
}
