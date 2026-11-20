import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_item.freezed.dart';

enum FavoriteType {
  movie,
  tv,
  celebrity;

  static FavoriteType? fromStorage(String value) => switch (value) {
    'movie' => FavoriteType.movie,
    'tv' => FavoriteType.tv,
    'celebrity' => FavoriteType.celebrity,
    _ => null,
  };
}

@freezed
abstract class FavoriteItem with _$FavoriteItem {
  const factory FavoriteItem({
    required int itemId,
    required String title,
    required FavoriteType type,
    @Default('') String posterPath,
    String? overview,
    String? releaseDate,
  }) = _FavoriteItem;
}
