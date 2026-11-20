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

  bool isFavorite(int itemId, FavoriteType type) =>
      (state.value ?? const <FavoriteItem>[]).any(
        (item) => item.itemId == itemId && item.type == type,
      );

  Future<void> toggle(FavoriteItem item) async {
    final exists = isFavorite(item.itemId, item.type);
    await (exists ? _remove(item) : _add(item));
  }

  Future<void> _add(FavoriteItem item) async {
    final previous = state.value ?? const <FavoriteItem>[];
    state = AsyncData(List.unmodifiable([...previous, item]));

    try {
      await ref.read(favoritesRepositoryProvider).save(item);
    } catch (error, stackTrace) {
      state = AsyncData(previous);
      throw mapError(error, stackTrace);
    }
  }

  Future<void> _remove(FavoriteItem item) async {
    final previous = state.value ?? const <FavoriteItem>[];
    state = AsyncData(
      List.unmodifiable(
        previous.where(
          (candidate) =>
              candidate.itemId != item.itemId || candidate.type != item.type,
        ),
      ),
    );

    try {
      await ref
          .read(favoritesRepositoryProvider)
          .remove(item.itemId, item.type);
    } catch (error, stackTrace) {
      state = AsyncData(previous);
      throw mapError(error, stackTrace);
    }
  }
}
