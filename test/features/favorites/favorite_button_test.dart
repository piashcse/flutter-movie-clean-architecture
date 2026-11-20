import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/domain/entities/favorite_item.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/presentation/favorite_button.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/presentation/providers/favorite_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeFavoritesRepository implements FavoritesRepository {
  final List<FavoriteItem> items = [];

  @override
  Future<List<FavoriteItem>> getAll() async => List.of(items);

  @override
  Future<void> save(FavoriteItem item) async => items.add(item);

  @override
  Future<void> remove(int itemId, FavoriteType type) async =>
      items.removeWhere((item) => item.itemId == itemId && item.type == type);
}

void main() {
  const movie = FavoriteItem(
    itemId: 1,
    title: 'Alien',
    type: FavoriteType.movie,
  );

  testWidgets('toggles the favourite and updates the icon', (tester) async {
    final repository = _FakeFavoritesRepository();
    final container = ProviderContainer(
      overrides: [favoritesRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    await container.read(favoritesProvider.future);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBar(actions: const [FavoriteButton(item: movie)]),
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(repository.items, [movie]);
  });
}
