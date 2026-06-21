import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/localization/localization_helper.dart';
import 'package:flutter_movie_clean_architecture/core/utils/utils.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/detail_sections.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/data/models/favorite_model.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/presentation/providers/favorite_provider.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final descriptionExpandedProvider = StateProvider<bool>((ref) => false);

class MovieDetailPage extends ConsumerWidget {
  final int movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieDetailAsync = ref.watch(movieDetailProvider(movieId));
    final recommendMovieAsync = ref.watch(recommendMovieProvider(movieId));
    final movieCreditAsync = ref.watch(movieCreditsProvider(movieId));
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: movieDetailAsync.when(
        data: (movie) {
          final isFavorite = favorites.any(
            (fav) => fav.itemId == movie.id && fav.type == 'movie',
          );

          return CustomScrollView(
            slivers: [
              MovieDetailHeader(movie: movie, isFavorite: isFavorite),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    MovieDetailInfoSection(movie: movie),
                    DescriptionSection(
                      overview: movie.overview ?? '',
                      expandedProvider: descriptionExpandedProvider,
                    ),
                    RecommendationsSection(
                      itemsAsync: recommendMovieAsync,
                      titleKey: 'recommended_movies',
                      errorKey: 'failed_to_load_recommended_movies',
                      idGetter: (item) => item.id.toString(),
                      posterPathGetter: (item) => item.posterPath,
                      routePrefix: '/movie',
                    ),
                    CreditsSection(creditsAsync: movieCreditAsync),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(context.translate('error_loading_movie_details'),
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(error.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
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

class MovieDetailHeader extends ConsumerWidget {
  final dynamic movie;
  final bool isFavorite;

  const MovieDetailHeader({super.key, required this.movie, required this.isFavorite});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesNotifier = ref.read(favoritesProvider.notifier);

    void toggleFavorite() {
      final favorite = Favorite(
        id: DateTime.now().millisecondsSinceEpoch,
        itemId: movie.id,
        title: movie.title ?? 'Unknown Title',
        posterPath: movie.posterPath ?? '',
        type: 'movie',
        overview: movie.overview,
        releaseDate: movie.releaseDate,
      );

      favoritesNotifier.toggleFavorite(favorite);
    }

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: const Text(
        'Movie Detail',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.white,
          ),
          onPressed: toggleFavorite,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            movie.posterPath != null
                ? Image.network(
                    '$imageUrl${movie.posterPath}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      child:
                          Icon(Icons.movie, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  )
                : Container(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    child:
                        Icon(Icons.movie, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
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

class MovieDetailInfoSection extends StatelessWidget {
  final dynamic movie;

  const MovieDetailInfoSection({super.key, required this.movie});

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
              child: movie.posterPath != null
                  ? Image.network(
                      '$imageUrl${movie.posterPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        child: Icon(Icons.movie, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    )
                  : Container(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      child: Icon(Icons.movie, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title ?? 'Unknown Title',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoItem(
                        context,
                        'Duration',
                        movie.runtime != null
                            ? formatDuration(movie.runtime!)
                            : 'N/A'),
                    _buildInfoItem(context, 'Release Date', movie.releaseDate ?? 'N/A'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoItem(context, 'Language',
                        movie.originalLanguage?.toUpperCase() ?? 'N/A'),
                    _buildInfoItem(context, 'Rating',
                        movie.voteAverage?.toStringAsFixed(1) ?? 'N/A'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}


