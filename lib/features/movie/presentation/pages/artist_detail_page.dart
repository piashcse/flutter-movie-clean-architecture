import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/entities/credit_entity.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/app_status_views.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/cached_image.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/description_section.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/recommendations_section.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/domain/entities/favorite_item.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/presentation/favorite_button.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/artist_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_movie_clean_architecture/routing/app_routes.dart';
import 'package:flutter_movie_clean_architecture/routing/navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArtistDetailPage extends ConsumerWidget {
  const ArtistDetailPage({super.key, required this.artistId});

  final int artistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(artistDetailProvider(artistId));
    final creditsAsync = ref.watch(artistCreditsProvider(artistId));
    final l10n = context.l10n;

    return Scaffold(
      body: detailAsync.when(
        data: (artist) => CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: Text(
                artist.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () => popOrGoHome(context),
              ),
              actions: [FavoriteButton(item: _toFavorite(artist))],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ArtistHeader(artist: artist),
                    const SizedBox(height: 16),
                    if (artist.placeOfBirth.isNotEmpty)
                      _InfoRow(
                        icon: Icons.location_on_outlined,
                        label: l10n.placeOfBirth,
                        value: artist.placeOfBirth,
                      ),
                    if (artist.birthday.isNotEmpty)
                      _InfoRow(
                        icon: Icons.cake_outlined,
                        label: l10n.birthday,
                        value: artist.birthday,
                      ),
                    const SizedBox(height: 16),
                    DescriptionSection(
                      title: l10n.biography,
                      text: artist.biography,
                      emptyMessage: l10n.noBiographyAvailable,
                    ),
                    RecommendationsSection<CastMember>(
                      itemsAsync: creditsAsync.whenData(
                        (credits) => credits.cast,
                      ),
                      title: l10n.moviesAndTvShows,
                      errorText: l10n.failedToLoadMovies,
                      imageOf: (credit) => credit.posterPath,
                      routeOf: (credit) => credit.mediaType == 'tv'
                          ? AppRoutes.tv(credit.id)
                          : AppRoutes.movie(credit.id),
                      itemLabelOf: (credit) => credit.character,
                      onRetry: () =>
                          ref.invalidate(artistCreditsProvider(artistId)),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: AppLoadingView.new,
        error: (error, _) => AppErrorView(
          error: error,
          onRetry: () => ref.invalidate(artistDetailProvider(artistId)),
        ),
      ),
    );
  }

  FavoriteItem _toFavorite(ArtistDetail artist) => FavoriteItem(
    itemId: artist.id,
    title: artist.name,
    posterPath: artist.profilePath ?? '',
    type: FavoriteType.celebrity,
    overview: artist.biography,
  );
}

class _ArtistHeader extends StatelessWidget {
  const _ArtistHeader({required this.artist});

  final ArtistDetail artist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          height: 180,
          child: CachedImage(
            imageUrl: tmdbImage(artist.profilePath),
            borderRadius: 12,
            errorIcon: Icons.person,
            semanticLabel: artist.name,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                artist.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.artistDetail,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                artist.knownForDepartment.isEmpty
                    ? l10n.acting
                    : artist.knownForDepartment,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}
