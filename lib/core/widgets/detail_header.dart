import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/cached_image.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/domain/entities/favorite_item.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/presentation/favorite_button.dart';
import 'package:flutter_movie_clean_architecture/routing/navigation.dart';

/// Shared collapsing header used by the movie and TV detail screens.
class DetailHeader extends StatelessWidget {
  const DetailHeader({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.favorite,
    this.fallbackIcon = Icons.movie,
  });

  final String title;
  final String? imageUrl;
  final FavoriteItem favorite;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: colors.primary,
      foregroundColor: colors.onPrimary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () => popOrGoHome(context),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: colors.onPrimary),
      ),
      actions: [FavoriteButton(item: favorite)],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedImage(
              imageUrl: imageUrl,
              errorIcon: fallbackIcon,
              semanticLabel: title,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
