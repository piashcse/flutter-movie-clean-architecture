import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series_detail.dart';

part 'tv_series_detail_model.freezed.dart';
part 'tv_series_detail_model.g.dart';

@freezed
class TvSeriesDetailModel with _$TvSeriesDetailModel {
  const factory TvSeriesDetailModel({
    required int id,
    required String name,
    @JsonKey(name: 'poster_path') String? posterPath,
    required String overview,
    @JsonKey(name: 'first_air_date') required String firstAirDate,
    @JsonKey(name: 'vote_average') required double voteAverage,
  }) = _TvSeriesDetailModel;

  factory TvSeriesDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TvSeriesDetailModelFromJson(json);
}