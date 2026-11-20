import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';

@freezed
abstract class Movie with _$Movie {
  const factory Movie({
    required int id,
    @Default('') String title,
    String? posterPath,
    @Default('') String overview,
  }) = _Movie;
}
