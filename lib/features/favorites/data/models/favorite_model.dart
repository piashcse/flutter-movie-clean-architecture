import 'package:flutter_movie_clean_architecture/features/favorites/domain/entities/favorite_item.dart';
import 'package:hive/hive.dart';

/// Persisted representation of a favourite. Kept separate from the domain
/// [FavoriteItem] so Hive/field ids never leak into the UI layer.
@HiveType(typeId: 0)
class Favorite extends HiveObject {
  Favorite({
    required this.itemId,
    required this.title,
    required this.posterPath,
    required this.type,
    this.overview,
    this.releaseDate,
  });

  @HiveField(0)
  late int id;

  @HiveField(1)
  late int itemId;

  @HiveField(2)
  late String title;

  @HiveField(3)
  late String posterPath;

  @HiveField(4)
  late String type;

  @HiveField(5)
  String? overview;

  @HiveField(6)
  String? releaseDate;
}

extension FavoriteMapper on Favorite {
  FavoriteItem toEntity() => FavoriteItem(
    itemId: itemId,
    title: title,
    posterPath: posterPath,
    type: FavoriteType.fromStorage(type) ?? FavoriteType.movie,
    overview: overview,
    releaseDate: releaseDate,
  );
}

extension FavoriteItemMapper on FavoriteItem {
  Favorite toModel() => Favorite(
    itemId: itemId,
    title: title,
    posterPath: posterPath,
    type: type.name,
    overview: overview,
    releaseDate: releaseDate,
  )..id = itemId;
}
