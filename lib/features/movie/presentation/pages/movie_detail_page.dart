import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/utils/utils.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/models/credit_model.dart';
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: movieDetailAsync.when(
        data: (movie) => CustomScrollView(
          slivers: [
            MovieDetailHeader(movie: movie),
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
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF7B2CBF)),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading movie details',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieDetailHeader extends StatelessWidget {
  final dynamic movie;

  const MovieDetailHeader({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: const Color(0xFF7B2CBF),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Movie Detail',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            movie.posterPath != null
                ? Image.network(
                    '$IMAGE_URL${movie.posterPath}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child:
                          const Icon(Icons.movie, size: 64, color: Colors.grey),
                    ),
                  )
                : Container(
                    color: Colors.grey[300],
                    child:
                        const Icon(Icons.movie, size: 64, color: Colors.grey),
                  ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
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
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: movie.posterPath != null
                  ? Image.network(
                      '$IMAGE_URL${movie.posterPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.movie, color: Colors.grey),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.movie, color: Colors.grey),
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
                        movie.runtime != null
                            ? formatDuration(movie.runtime!)
                            : 'N/A'),
                    _buildInfoItem('Release Date', movie.releaseDate ?? 'N/A'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoItem('Language',
                        movie.originalLanguage?.toUpperCase() ?? 'N/A'),
                    _buildInfoItem('Rating',
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

class MovieDescriptionSection extends ConsumerWidget {
  final dynamic movie;

  const MovieDescriptionSection({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(descriptionExpandedProvider);
    final overview = movie.overview ?? 'No description available.';
    const maxLength = 95;

    final displayText = isExpanded || overview.length <= maxLength
        ? overview
        : overview.substring(0, maxLength).trimRight();

    final toggleText = isExpanded ? ' Show less' : ' Show more';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
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
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                'Recommended Movies',
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
                              '$IMAGE_URL${movie.posterPath}',
                              width: 110,
                              height: 160,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _errorPlaceholder(),
                            )
                          : _errorPlaceholder(),
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
          'Failed to load recommended movies.',
          style: TextStyle(color: Colors.red[400]),
        ),
      ),
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      width: 100,
      height: 160,
      color: Colors.grey[300],
      child: const Icon(Icons.movie, size: 48, color: Colors.grey),
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
                  final imageUrl = cast.profilePath != null
                      ? '$IMAGE_URL${cast.profilePath}'
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
                                    errorBuilder: (_, __, ___) =>
                                        _placeholder(),
                                  )
                                : _placeholder(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cast.name ?? 'Unknown',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
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
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF7B2CBF),
          ),
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          'Failed to load cast.',
          style: TextStyle(color: Colors.red[400]),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: Colors.grey, size: 35),
    );
  }
}
