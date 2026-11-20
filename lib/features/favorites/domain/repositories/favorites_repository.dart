import 'package:flutter_movie_clean_architecture/features/favorites/domain/entities/favorite_item.dart';

abstract interface class FavoritesRepository {
  Future<List<FavoriteItem>> getAll();

  Future<void> save(FavoriteItem item);

  Future<void> remove(int itemId, FavoriteType type);
}
