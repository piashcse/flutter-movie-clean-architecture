import 'package:flutter_movie_clean_architecture/features/favorites/data/models/favorite_model.dart';
import 'package:hive/hive.dart';

/// Hive-backed storage for favourites. Accepts the box via constructor so it
/// can run against a temporary box in tests.
class FavoritesLocalDataSource {
  const FavoritesLocalDataSource(this._box);

  final Box<Favorite> _box;

  List<Favorite> readAll() => _box.values.toList(growable: false);

  Future<void> save(Favorite favorite) =>
      _box.put(_key(favorite.itemId, favorite.type), favorite);

  Future<void> delete(int itemId, String type) =>
      _box.delete(_key(itemId, type));

  String _key(int itemId, String type) => '${itemId}_$type';
}
