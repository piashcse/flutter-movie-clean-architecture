import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series.dart';

part 'tv_series_model.freezed.dart';
part 'tv_series_model.g.dart';

@freezed
class TvSeriesModel with _$TvSeriesModel {
  const factory TvSeriesModel({
    required int id,
    required String name,
    @JsonKey(name: 'poster_path') String? posterPath,
    required String overview,
  }) = _TvSeriesModel;

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) => _$TvSeriesModelFromJson(json);
}