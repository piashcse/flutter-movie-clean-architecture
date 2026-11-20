import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_series_detail.freezed.dart';

@freezed
abstract class TvSeriesDetail with _$TvSeriesDetail {
  const factory TvSeriesDetail({
    required int id,
    @Default('') String name,
    String? posterPath,
    @Default('') String overview,
    @Default(0) double voteAverage,
    @Default('') String firstAirDate,
    @Default('') String originalLanguage,
    @Default(<int>[]) List<int> episodeRunTime,
    String? lastAirDate,
    @Default(0) int numberOfEpisodes,
    @Default(0) int numberOfSeasons,
  }) = _TvSeriesDetail;
}
