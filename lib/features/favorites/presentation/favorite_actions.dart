import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/error/failure_messages.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/domain/entities/favorite_item.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/presentation/providers/favorite_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Toggles a favourite and surfaces storage failures as a snack bar.
///
/// Captures the localisations and messenger before awaiting so it is safe to
/// call from widgets that may be disposed while the write completes.
Future<void> toggleFavorite(
  BuildContext context,
  WidgetRef ref,
  FavoriteItem item,
) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.maybeOf(context);

  try {
    await ref.read(favoritesProvider.notifier).toggle(item);
  } catch (error) {
    messenger?.showSnackBar(
      SnackBar(content: Text(failureMessageFor(l10n, error))),
    );
  }
}

/// Read-only lookup used by detail screens to render the favourite icon.
bool isFavorite(WidgetRef ref, int itemId, FavoriteType type) {
  final favorites = ref.watch(favoritesProvider).value;
  return favorites?.any((item) => item.itemId == itemId && item.type == type) ??
      false;
}
