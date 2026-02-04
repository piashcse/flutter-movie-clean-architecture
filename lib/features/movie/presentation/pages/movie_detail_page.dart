import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/hive/favorite_model.dart';
import 'package:flutter_movie_clean_architecture/core/localization/localization_helper.dart';
import 'package:flutter_movie_clean_architecture/core/utils/utils.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/models/credit_model.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/favorite_provider.dart';
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
          // Check if movie is favorited
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
                    MovieDescriptionSection(movie: movie),
                    RecommendedMoviesSection(
                        recommendMovieAsync: recommendMovieAsync),
                    MovieCreditsSection(movieCreditAsync: movieCreditAsync),
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
                onPressed: () => Navigator.pop(context),
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
        onPressed: () => Navigator.pop(context),
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

class MovieDescriptionSection extends ConsumerWidget {
  final dynamic movie;

  const MovieDescriptionSection({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(descriptionExpandedProvider);
    final overview = movie.overview ?? context.translate('no_description_available');
    const maxLength = 95;

    final displayText = isExpanded || overview.length <= maxLength
        ? overview
        : overview.substring(0, maxLength).trimRight();

    final toggleText = isExpanded ? ' ${context.translate('show_less')}' : ' ${context.translate('show_more')}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate('description'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => ref.read(descriptionExpandedProvider.notifier).state =
                !isExpanded,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: displayText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  TextSpan(
                    text: toggleText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF00BCD4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendedMoviesSection extends StatelessWidget {
  final AsyncValue<List<dynamic>> recommendMovieAsync;

  const RecommendedMoviesSection(
      {super.key, required this.recommendMovieAsync});

  @override
  Widget build(BuildContext context) {
    return recommendMovieAsync.when(
      data: (recommendedMovies) {
        if (recommendedMovies.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                context.translate('recommended_movies'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: recommendedMovies.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final movie = recommendedMovies[index];
                  return GestureDetector(
                    onTap: () => context.push('/movie/${movie.id}'),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: movie.posterPath != null
                          ? Image.network(
                              '$imageUrl${movie.posterPath}',
                              width: 110,
                              height: 160,
                              fit: BoxFit.cover,
                              errorBuilder: (context, _, __) => _errorPlaceholder(context),
                            )
                          : _errorPlaceholder(context),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
            context.translate('failed_to_load_recommended_movies'),
            style: TextStyle(color: Colors.red[400]),
          ),
      ),
    );
  }

  Widget _errorPlaceholder(BuildContext context) {
    return Container(
      width: 100,
      height: 160,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      child: Icon(Icons.movie, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}

class MovieCreditsSection extends StatelessWidget {
  final AsyncValue movieCreditAsync;

  const MovieCreditsSection({super.key, required this.movieCreditAsync});

  @override
  Widget build(BuildContext context) {
    return movieCreditAsync.when(
      data: (credits) {
        final castList = credits?.cast ?? <Cast>[];
        if (castList.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Cast',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(
              height: 140, // Increased height to accommodate names
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: castList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 4),
                itemBuilder: (context, index) {
                  final cast = castList[index];
                  final castImageUrl = cast.profilePath != null
                      ? '$imageUrl${cast.profilePath}'
                      : null;

                  return InkWell(
                    onTap: () {
                      // Navigate to artist detail using GoRouter
                      context.push('/artistId/${cast.id}');
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: SizedBox(
                      width: 80, // Fixed width for consistent layout
                      child: Column(
                        children: [
                          ClipOval(
                            child: imageUrl != null
                                ? Image.network(
                                    imageUrl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, _, __) =>
                                        _placeholder(context),
                                  )
                                : _placeholder(context),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cast.name ?? 'Unknown',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
      loading: () => Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          context.translate('failed_to_load_cast'),
          style: TextStyle(color: Colors.red[400]),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 35),
    );
  }
}
