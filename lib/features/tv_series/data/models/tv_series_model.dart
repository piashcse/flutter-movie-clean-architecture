import 'package:freezed_annotation/freezed_annotation.dart';

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

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) =>
      _$TvSeriesModelFromJson(json);
}