import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_series_detail_model.freezed.dart';
part 'tv_series_detail_model.g.dart';

@freezed
abstract class TvSeriesDetailModel with _$TvSeriesDetailModel {
  const factory TvSeriesDetailModel({
    @Default(0) int id,
    @Default('') String name,
    @JsonKey(name: 'poster_path') String? posterPath,
    @Default('') String overview,
    @JsonKey(name: 'vote_average') @Default(0) double voteAverage,
    @JsonKey(name: 'first_air_date') @Default('') String firstAirDate,
    @JsonKey(name: 'original_language') @Default('') String originalLanguage,
    @JsonKey(name: 'episode_run_time')
    @Default(<int>[])
    List<int> episodeRunTime,
    @JsonKey(name: 'last_air_date') String? lastAirDate,
    @JsonKey(name: 'number_of_episodes') @Default(0) int numberOfEpisodes,
    @JsonKey(name: 'number_of_seasons') @Default(0) int numberOfSeasons,
  }) = _TvSeriesDetailModel;

  factory TvSeriesDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TvSeriesDetailModelFromJson(json);
}
