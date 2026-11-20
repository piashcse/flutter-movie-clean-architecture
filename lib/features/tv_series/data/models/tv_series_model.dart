import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_series_model.freezed.dart';
part 'tv_series_model.g.dart';

@freezed
abstract class TvSeriesModel with _$TvSeriesModel {
  const factory TvSeriesModel({
    @Default(0) int id,
    @Default('') String name,
    @JsonKey(name: 'poster_path') String? posterPath,
    @Default('') String overview,
  }) = _TvSeriesModel;

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) =>
      _$TvSeriesModelFromJson(json);
}
