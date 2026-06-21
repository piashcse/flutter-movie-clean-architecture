import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/localization/localization_helper.dart';
import 'package:flutter_movie_clean_architecture/core/utils/utils.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/cached_image.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/detail_sections.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/data/models/favorite_model.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/presentation/providers/favorite_provider.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/providers/tv_series_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final tvDescriptionExpandedProvider = StateProvider<bool>((ref) => false);

class TvSeriesDetailPage extends ConsumerWidget {
  final int tvSeriesId;

  const TvSeriesDetailPage({super.key, required this.tvSeriesId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tvSeriesDetailAsync = ref.watch(tvSeriesDetailProvider(tvSeriesId));
    final recommendedTvSeriesAsync = ref.watch(recommendedTvSeriesProvider(tvSeriesId));
    final tvSeriesCreditsAsync = ref.watch(tvSeriesCreditsProvider(tvSeriesId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: tvSeriesDetailAsync.when(
        data: (tvSeries) => CustomScrollView(
          slivers: [
            TvSeriesDetailHeader(tvSeries: tvSeries),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  TvSeriesDetailInfoSection(tvSeries: tvSeries),
                  DescriptionSection(
                    overview: tvSeries.overview ?? '',
                    expandedProvider: tvDescriptionExpandedProvider,
                  ),
                  RecommendationsSection(
                    itemsAsync: recommendedTvSeriesAsync,
                    titleKey: 'recommended_tv_series',
                    errorKey: 'failed_to_load_recommended_tv_series',
                    idGetter: (item) => item.id.toString(),
                    posterPathGetter: (item) => item.posterPath,
                    routePrefix: '/tv',
                    errorIcon: Icons.tv,
                  ),
                  CreditsSection(creditsAsync: tvSeriesCreditsAsync),
                ],
              ),
            ),
          ],
        ),
        loading: () => Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(context.translate('error_loading_tv_series_details'),
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: Text(context.translate('go_back')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TvSeriesDetailHeader extends ConsumerWidget {
  final dynamic tvSeries;

  const TvSeriesDetailHeader({super.key, required this.tvSeries});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.any(
      (fav) => fav.itemId == tvSeries.id && fav.type == 'tv',
    );

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: const Text(
        'TV Series Detail',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.white,
          ),
          onPressed: () {
            final favorite = Favorite(
              id: DateTime.now().millisecondsSinceEpoch,
              itemId: tvSeries.id,
              title: tvSeries.name ?? 'Unknown Title',
              posterPath: tvSeries.posterPath ?? '',
              type: 'tv',
              overview: tvSeries.overview,
              releaseDate: tvSeries.firstAirDate,
            );
            ref.read(favoritesProvider.notifier).toggleFavorite(favorite);
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedImage(
              imageUrl: tvSeries.posterPath != null ? '$imageUrl${tvSeries.posterPath}' : null,
              fit: BoxFit.cover,
              errorIcon: Icons.movie,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TvSeriesDetailInfoSection extends StatelessWidget {
  final dynamic tvSeries;

  const TvSeriesDetailInfoSection({super.key, required this.tvSeries});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 120,
              height: 180,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CachedImage(
                imageUrl: tvSeries.posterPath != null ? '$imageUrl${tvSeries.posterPath}' : null,
                fit: BoxFit.cover,
                errorIcon: Icons.movie,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tvSeries.name ?? 'Unknown Title',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoItem(
                        'Duration',
                        formatTvDuration(tvSeries.episodeRunTime)),
                    _buildInfoItem('First Air Date', tvSeries.firstAirDate ?? 'N/A'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoItem('Language',
                        tvSeries.originalLanguage?.toUpperCase() ?? 'N/A'),
                    _buildInfoItem('Rating',
                        tvSeries.voteAverage?.toStringAsFixed(1) ?? 'N/A'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoItem('Episodes', tvSeries.numberOfEpisodes?.toString() ?? 'N/A'),
                    _buildInfoItem('Seasons', tvSeries.numberOfSeasons?.toString() ?? 'N/A'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

