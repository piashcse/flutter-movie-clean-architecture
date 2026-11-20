import 'dart:io';

import 'package:flutter_movie_clean_architecture/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/data/models/favorite_adapter.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/data/models/favorite_model.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/domain/entities/favorite_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;
  late Box<Favorite> box;
  late FavoritesRepositoryImpl repository;
  var boxCounter = 0;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp(
      'favorites_repository_test',
    );
    Hive.init(tempDir.path);
    Hive.registerAdapter(FavoriteAdapter());
  });

  setUp(() async {
    box = await Hive.openBox<Favorite>('favorites_${boxCounter++}');
    repository = FavoritesRepositoryImpl(FavoritesLocalDataSource(box));
  });

  tearDown(() async {
    await box.deleteFromDisk();
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  const movie = FavoriteItem(
    itemId: 1,
    title: 'Alien',
    posterPath: '/alien.jpg',
    type: FavoriteType.movie,
  );

  test('persists and reads back favourites', () async {
    await repository.save(movie);

    expect(await repository.getAll(), [movie]);
  });

  test(
    'overwrites an existing favourite with the same item and type',
    () async {
      await repository.save(movie);
      await repository.save(movie.copyWith(title: 'Alien (1979)'));

      final favorites = await repository.getAll();
      expect(favorites, hasLength(1));
      expect(favorites.single.title, 'Alien (1979)');
    },
  );

  test('removes favourites by item id and type', () async {
    await repository.save(movie);
    await repository.save(
      movie.copyWith(itemId: 2, type: FavoriteType.tv, title: 'The Bear'),
    );

    await repository.remove(movie.itemId, FavoriteType.movie);

    final favorites = await repository.getAll();
    expect(favorites, hasLength(1));
    expect(favorites.single.type, FavoriteType.tv);
  });
}
