import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/core/utils/layout.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/app_status_views.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/cached_image.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/shimmer_placeholders.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/domain/entities/favorite_item.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/presentation/favorite_actions.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/presentation/providers/favorite_provider.dart';
import 'package:flutter_movie_clean_architecture/routing/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favorites)),
      body: favoritesAsync.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return AppEmptyView(
              message: l10n.noFavoritesYet,
              description: l10n.startAddingFavorites,
              icon: Icons.favorite_border,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(favoritesProvider);
              await ref.read(favoritesProvider.future);
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridColumnsForWidth(constraints.maxWidth),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) =>
                      _FavoriteCard(item: favorites[index]),
                );
              },
            ),
          );
        },
        loading: MediaGridSkeleton.new,
        error: (error, _) => AppErrorView(
          error: error,
          onRetry: () => ref.invalidate(favoritesProvider),
        ),
      ),
    );
  }
}

class _FavoriteCard extends ConsumerWidget {
  const _FavoriteCard({required this.item});

  final FavoriteItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final typeLabel = switch (item.type) {
      FavoriteType.movie => l10n.typeMovie,
      FavoriteType.tv => l10n.typeTv,
      FavoriteType.celebrity => l10n.typeCelebrity,
    };

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(_routeFor(item)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: CachedImage(
                  imageUrl: tmdbImage(item.posterPath),
                  errorIcon: item.type == FavoriteType.celebrity
                      ? Icons.person
                      : Icons.movie,
                  semanticLabel: item.title,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 4, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          typeLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: l10n.removeFromFavorites,
                        icon: Icon(
                          Icons.favorite,
                          size: 18,
                          color: theme.colorScheme.error,
                        ),
                        onPressed: () => toggleFavorite(context, ref, item),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _routeFor(FavoriteItem item) => switch (item.type) {
    FavoriteType.movie => AppRoutes.movie(item.itemId),
    FavoriteType.tv => AppRoutes.tv(item.itemId),
    FavoriteType.celebrity => AppRoutes.artist(item.itemId),
  };
}
