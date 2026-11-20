import 'package:flutter_movie_clean_architecture/core/error/app_failure.dart';
import 'package:flutter_movie_clean_architecture/core/hive/hive_helper.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/domain/entities/favorite_item.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesLocalDataSourceProvider = Provider<FavoritesLocalDataSource>(
  (ref) => FavoritesLocalDataSource(HiveHelper.favoritesBox),
);

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepositoryImpl(ref.watch(favoritesLocalDataSourceProvider)),
);

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, List<FavoriteItem>>(
      FavoritesNotifier.new,
    );

class FavoritesNotifier extends AsyncNotifier<List<FavoriteItem>> {
  @override
  Future<List<FavoriteItem>> build() =>
      ref.watch(favoritesRepositoryProvider).getAll();

  /// Optimistically toggles [item], rolling back if storage fails.
  Future<void> toggle(FavoriteItem item) async {
    final previous = state.value ?? const <FavoriteItem>[];
    final exists = previous.any(
      (candidate) =>
          candidate.itemId == item.itemId && candidate.type == item.type,
    );

    final updated = exists
        ? previous.where(
            (candidate) =>
                candidate.itemId != item.itemId || candidate.type != item.type,
          )
        : <FavoriteItem>[...previous, item];

    state = AsyncData(List.unmodifiable(updated));

    try {
      final repository = ref.read(favoritesRepositoryProvider);
      if (exists) {
        await repository.remove(item.itemId, item.type);
      } else {
        await repository.save(item);
      }
    } catch (error, stackTrace) {
      state = AsyncData(previous);
      throw mapError(error, stackTrace);
    }
  }
}
