import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_series.freezed.dart';

@freezed
abstract class TvSeries with _$TvSeries {
  const factory TvSeries({
    required int id,
    @Default('') String name,
    String? posterPath,
    @Default('') String overview,
  }) = _TvSeries;
}
