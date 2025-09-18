import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_movie_clean_architecture/core/hive/favorite_model.dart';

class HiveHelper {
  static const String _boxName = 'favorites_box';
  static Box<Favorite>? _box;

  static Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();
    
    // Register adapter
    Hive.registerAdapter(FavoriteAdapter());
    
    // Open box
    _box = await Hive.openBox<Favorite>(_boxName);
  }

  static Box<Favorite> _getBox() {
    if (_box == null) {
      throw Exception('HiveHelper not initialized. Call init() first.');
    }
    return _box!;
  }

  // Insert a favorite
  static Future<void> insertFavorite(Favorite favorite) async {
    final box = _getBox();
    await box.put('${favorite.itemId}_${favorite.type}', favorite);
  }

  // Delete a favorite
  static Future<void> deleteFavorite(int itemId, String type) async {
    final box = _getBox();
    await box.delete('${itemId}_$type');
  }

  // Check if an item is favorite
  static Future<bool> isFavorite(int itemId, String type) async {
    final box = _getBox();
    return box.containsKey('${itemId}_$type');
  }

  // Get all favorites
  static Future<List<Favorite>> getAllFavorites() async {
    final box = _getBox();
    return box.values.toList();
  }

  // Get favorites by type
  static Future<List<Favorite>> getFavoritesByType(String type) async {
    final box = _getBox();
    return box.values.where((favorite) => favorite.type == type).toList();
  }

  // Close Hive
  static Future<void> close() async {
    await _box?.close();
  }
}