import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_movie_clean_architecture/core/hive/hive_helper.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/data/models/favorite_model.dart';

// State provider to track favorites
final favoritesProvider = NotifierProvider<FavoritesNotifier, List<Favorite>>(
  FavoritesNotifier.new,
);

class FavoritesNotifier extends Notifier<List<Favorite>> {
  @override
  List<Favorite> build() {
    loadFavorites();
    return const [];
  }

  Future<void> loadFavorites() async {
    try {
      final favorites = await HiveHelper.getAllFavorites();
      state = List.unmodifiable(favorites);
    } catch (e) {
      state = const [];
    }
  }

  bool isFavorite(int itemId, String type) {
    return state.any((fav) => fav.itemId == itemId && fav.type == type);
  }

  Future<void> toggleFavorite(Favorite favorite) async {
    try {
      final existingIndex = state.indexWhere(
        (fav) => fav.itemId == favorite.itemId && fav.type == favorite.type,
      );

      if (existingIndex >= 0) {
        // Remove from favorites
        await HiveHelper.deleteFavorite(favorite.itemId, favorite.type);
        final newState = List<Favorite>.from(state)..removeAt(existingIndex);
        state = List.unmodifiable(newState);
      } else {
        // Add to favorites
        await HiveHelper.insertFavorite(favorite);
        final newState = List<Favorite>.from(state)..add(favorite);
        state = List.unmodifiable(newState);
      }
    } catch (e) {
      // Handle error - maybe show error state
      // Removed print statement for production code
    }
  }

  Future<void> addFavorite(Favorite favorite) async {
    try {
      final exists = state.any(
        (fav) => fav.itemId == favorite.itemId && fav.type == favorite.type,
      );

      if (!exists) {
        await HiveHelper.insertFavorite(favorite);
        final newState = List<Favorite>.from(state)..add(favorite);
        state = List.unmodifiable(newState);
      }
    } catch (e) {
      // Removed print statement for production code
    }
  }

  Future<void> removeFavorite(int itemId, String type) async {
    try {
      final existingIndex = state.indexWhere(
        (fav) => fav.itemId == itemId && fav.type == type,
      );

      if (existingIndex >= 0) {
        await HiveHelper.deleteFavorite(itemId, type);
        final newState = List<Favorite>.from(state)..removeAt(existingIndex);
        state = List.unmodifiable(newState);
      }
    } catch (e) {
      // Removed print statement for production code
    }
  }
}