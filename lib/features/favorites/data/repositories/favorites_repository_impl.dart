import 'package:flutter_movie_clean_architecture/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/data/models/favorite_model.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/domain/entities/favorite_item.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl(this._localDataSource);

  final FavoritesLocalDataSource _localDataSource;

  @override
  Future<List<FavoriteItem>> getAll() async => _localDataSource
      .readAll()
      .map((favorite) => favorite.toEntity())
      .toList(growable: false);

  @override
  Future<void> save(FavoriteItem item) => _localDataSource.save(item.toModel());

  @override
  Future<void> remove(int itemId, FavoriteType type) =>
      _localDataSource.delete(itemId, type.name);
}
