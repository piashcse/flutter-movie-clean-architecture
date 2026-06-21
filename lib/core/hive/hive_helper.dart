import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/data/models/favorite_model.dart';

class HiveHelper {
  static const String _favoritesBoxName = 'favorites_box';
  static const String _settingsBoxName = 'settings';

  static Box<Favorite>? _favoritesBox;
  static Box? _settingsBox;

  static Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapter
    Hive.registerAdapter(FavoriteAdapter());

    // Open boxes
    _favoritesBox = await Hive.openBox<Favorite>(_favoritesBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  static Box<Favorite> _getFavoritesBox() {
    if (_favoritesBox == null) {
      throw Exception('HiveHelper not initialized. Call init() first.');
    }
    return _favoritesBox!;
  }

  // Insert a favorite
  static Future<void> insertFavorite(Favorite favorite) async {
    final box = _getFavoritesBox();
    await box.put('${favorite.itemId}_${favorite.type}', favorite);
  }

  // Delete a favorite
  static Future<void> deleteFavorite(int itemId, String type) async {
    final box = _getFavoritesBox();
    await box.delete('${itemId}_$type');
  }

  // Check if an item is favorite
  static Future<bool> isFavorite(int itemId, String type) async {
    final box = _getFavoritesBox();
    return box.containsKey('${itemId}_$type');
  }

  // Get all favorites
  static Future<List<Favorite>> getAllFavorites() async {
    final box = _getFavoritesBox();
    return box.values.toList();
  }

  // Get favorites by type
  static Future<List<Favorite>> getFavoritesByType(String type) async {
    final box = _getFavoritesBox();
    return box.values.where((favorite) => favorite.type == type).toList();
  }

  // Close Hive
  static Future<void> close() async {
    await _favoritesBox?.close();
  }
}