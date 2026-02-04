import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_movie_clean_architecture/core/hive/hive_helper.dart';
import 'package:flutter_movie_clean_architecture/core/hive/favorite_model.dart';

// State provider to track favorites
final favoritesPageProvider = StateNotifierProvider<FavoritesPageNotifier, AsyncValue<List<Favorite>>>(
  (ref) => FavoritesPageNotifier(),
);

class FavoritesPageNotifier extends StateNotifier<AsyncValue<List<Favorite>>> {
  FavoritesPageNotifier() : super(const AsyncValue.loading()) {
    loadAllFavorites();
  }

  Future<void> loadAllFavorites() async {
    state = const AsyncValue.loading();
    try {
      final favorites = await HiveHelper.getAllFavorites();
      state = AsyncValue.data(favorites);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> loadFavoritesByType(String type) async {
    state = const AsyncValue.loading();
    try {
      final favorites = await HiveHelper.getFavoritesByType(type);
      state = AsyncValue.data(favorites);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> removeFavorite(int itemId, String type) async {
    try {
      await HiveHelper.deleteFavorite(itemId, type);
      // Reload the favorites after removal
      if (state.hasValue) {
        final updatedFavorites = state.value!.where((fav) => !(fav.itemId == itemId && fav.type == type)).toList();
        state = AsyncValue.data(updatedFavorites);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}