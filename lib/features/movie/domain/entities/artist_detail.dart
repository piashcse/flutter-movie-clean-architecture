import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist_detail.freezed.dart';

@freezed
abstract class ArtistDetail with _$ArtistDetail {
  const factory ArtistDetail({
    required int id,
    @Default('') String name,
    String? profilePath,
    @Default('') String biography,
    @Default('') String knownForDepartment,
    @Default('') String placeOfBirth,
    @Default('') String birthday,
  }) = _ArtistDetail;
}
