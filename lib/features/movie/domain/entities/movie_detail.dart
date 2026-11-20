import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_detail.freezed.dart';

@freezed
abstract class MovieDetail with _$MovieDetail {
  const factory MovieDetail({
    required int id,
    @Default('') String title,
    @Default('') String overview,
    String? posterPath,
    @Default('') String releaseDate,
    @Default(0) double voteAverage,
    @Default(0) int runtime,
    @Default('') String originalLanguage,
  }) = _MovieDetail;
}
