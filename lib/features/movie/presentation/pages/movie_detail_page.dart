import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Add this provider to manage description expansion state
final descriptionExpandedProvider = StateProvider<bool>((ref) => false);

class MovieDetailPage extends ConsumerWidget {
  final int movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieDetailAsync = ref.watch(movieDetailProvider(movieId));
    final isExpanded = ref.watch(descriptionExpandedProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: movieDetailAsync.when(
        data: (movie) => CustomScrollView(
          slivers: [
            SliverAppBar(
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
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.movie,
                                size: 64, color: Colors.grey),
                          ),
                    )
                        : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.movie,
                          size: 64, color: Colors.grey),
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
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
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
                                errorBuilder: (context, error,
                                    stackTrace) =>
                                    Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.movie,
                                          color: Colors.grey),
                                    ),
                              )
                                  : Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.movie,
                                    color: Colors.grey),
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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Duration',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            movie.runtime != null
                                                ? _formatDuration(
                                                movie.runtime!)
                                                : 'N/A',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Release Date',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            movie.releaseDate ?? 'N/A',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Language',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            movie.originalLanguage
                                                ?.toUpperCase() ??
                                                'N/A',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Rating',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            movie.voteAverage != null
                                                ? movie.voteAverage!
                                                .toStringAsFixed(1)
                                                : 'N/A',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Updated description section
                    Container(
                      width: double.infinity,
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
                          Text(
                            movie.overview ?? 'No description available.',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                            maxLines: isExpanded ? null : 3,
                            overflow: isExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          if (movie.overview != null &&
                              movie.overview!.length > 150)
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(descriptionExpandedProvider.notifier)
                                    .state = !isExpanded;
                              },
                              child: Text(
                                isExpanded ? 'Show less' : 'Show more',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF00BCD4),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => Scaffold(
          appBar: AppBar(
            title: const Text('Movie Detail'),
            backgroundColor: const Color(0xFF7B2CBF),
            foregroundColor: Colors.white,
          ),
          body: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF7B2CBF),
            ),
          ),
        ),
        error: (error, _) => Scaffold(
          appBar: AppBar(
            title: const Text('Movie Detail'),
            backgroundColor: const Color(0xFF7B2CBF),
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading movie details',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }
}