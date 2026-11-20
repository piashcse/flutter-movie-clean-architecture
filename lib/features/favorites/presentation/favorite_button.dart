import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/domain/entities/favorite_item.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/presentation/favorite_actions.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/presentation/providers/favorite_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Isolated favourite toggle so only this button rebuilds when the favourites
/// list changes, instead of the whole detail page.
class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({super.key, required this.item, this.color});

  final FavoriteItem item;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isFavorite =
        ref
            .watch(favoritesProvider)
            .value
            ?.any(
              (candidate) =>
                  candidate.itemId == item.itemId &&
                  candidate.type == item.type,
            ) ??
        false;

    return IconButton(
      tooltip: isFavorite ? l10n.removeFromFavorites : l10n.addToFavorites,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: color,
      ),
      onPressed: () => toggleFavorite(context, ref, item),
    );
  }
}
