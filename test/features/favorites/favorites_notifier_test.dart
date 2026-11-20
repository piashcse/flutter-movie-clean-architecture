import 'package:flutter_movie_clean_architecture/core/error/app_failure.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/domain/entities/favorite_item.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/presentation/providers/favorite_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeFavoritesRepository implements FavoritesRepository {
  final List<FavoriteItem> items = [];
  Object? failure;

  @override
  Future<List<FavoriteItem>> getAll() async => List.of(items);

  @override
  Future<void> save(FavoriteItem item) async {
    if (failure != null) {
      throw failure!;
    }
    items
      ..removeWhere(
        (candidate) =>
            candidate.itemId == item.itemId && candidate.type == item.type,
      )
      ..add(item);
  }

  @override
  Future<void> remove(int itemId, FavoriteType type) async {
    if (failure != null) {
      throw failure!;
    }
    items.removeWhere(
      (candidate) => candidate.itemId == itemId && candidate.type == type,
    );
  }
}

void main() {
  const movie = FavoriteItem(
    itemId: 1,
    title: 'Alien',
    type: FavoriteType.movie,
  );

  late _FakeFavoritesRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _FakeFavoritesRepository();
    container = ProviderContainer(
      overrides: [favoritesRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
  });

  test('builds from the repository', () async {
    repository.items.add(movie);

    expect(await container.read(favoritesProvider.future), [movie]);
  });

  test('toggles items on and off', () async {
    await container.read(favoritesProvider.future);
    final notifier = container.read(favoritesProvider.notifier);

    await notifier.toggle(movie);
    expect(container.read(favoritesProvider).value, [movie]);
    expect(repository.items, [movie]);

    await notifier.toggle(movie);
    expect(container.read(favoritesProvider).value, isEmpty);
    expect(repository.items, isEmpty);
  });

  test('rolls back optimistic updates when storage fails', () async {
    await container.read(favoritesProvider.future);
    final notifier = container.read(favoritesProvider.notifier);
    repository.failure = StateError('disk full');

    await expectLater(notifier.toggle(movie), throwsA(isA<AppFailure>()));
    expect(container.read(favoritesProvider).value, isEmpty);
  });
}
