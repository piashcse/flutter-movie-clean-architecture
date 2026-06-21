import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/localization/localization_helper.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/cached_image.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/data/models/favorite_model.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/presentation/providers/favorite_provider.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ArtistDetailPage extends ConsumerStatefulWidget {
  final int artistId;

  const ArtistDetailPage({super.key, required this.artistId});

  @override
  ConsumerState<ArtistDetailPage> createState() => _ArtistDetailPageState();
}

class ArtistMoviesSection extends StatelessWidget {
  final AsyncValue<dynamic> artistAllMoviesAsync;

  const ArtistMoviesSection({super.key, required this.artistAllMoviesAsync});

  @override
  Widget build(BuildContext context) {
    return artistAllMoviesAsync.when(
      data: (moviesResponse) {
        final movies = moviesResponse.cast;
        if (movies.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Text(
                context.translate('movies_and_tv_shows'),
                style: const TextStyle(
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
                itemCount: movies.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = movies[index];
                  return GestureDetector(
                    onTap: () {
                      if (item.mediaType == 'tv') {
                        context.push('/tv/${item.id}');
                      } else {
                        context.push('/movie/${item.id}');
                      }
                    },
                    child: CachedImage(
                      imageUrl: item.posterPath != null ? '$imageUrl${item.posterPath}' : null,
                      width: 110,
                      height: 160,
                      fit: BoxFit.cover,
                      borderRadius: 12,
                      errorIcon: Icons.movie,
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          context.translate('failed_to_load_movies'),
          style: TextStyle(color: Colors.red[400]),
        ),
      ),
    );
  }

}

class _ArtistDetailPageState extends ConsumerState<ArtistDetailPage> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final artistDetailAsync = ref.watch(artistDetailProvider(widget.artistId));
    final artistAllMoviesAsync = ref.watch(artistDetailAllMoviesProvider(widget.artistId));
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: artistDetailAsync.when(
        data: (artist) {
          final isFavorite = favorites.any(
            (fav) => fav.itemId == widget.artistId && fav.type == 'celebrity',
          );

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Colors.black,
                elevation: 0,
                pinned: true,
                floating: false,
                expandedHeight: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  artist.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      final favorite = Favorite(
                        id: DateTime.now().millisecondsSinceEpoch,
                        itemId: widget.artistId,
                        title: artist.name ?? 'Unknown Artist',
                        posterPath: artist.profilePath ?? '',
                        type: 'celebrity',
                        overview: artist.biography,
                        releaseDate: null,
                      );
                      ref.read(favoritesProvider.notifier).toggleFavorite(favorite);
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedImage(
                            imageUrl: artist.profilePath != null ? '$imageUrl${artist.profilePath}' : null,
                            width: 140,
                            height: 200,
                            borderRadius: 8,
                            errorIcon: Icons.person,
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  artist.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  context.translate('artist_detail'),
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                                Text(
                                  artist.knownForDepartment ?? context.translate('acting'),
                                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (artist.biography != null && artist.biography!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.translate('biography'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              artist.biography!,
                              maxLines: _isExpanded ? null : 5,
                              overflow: _isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                            if (artist.biography!.length > 200)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                child: Text(
                                  _isExpanded
                                      ? context.translate('show_less')
                                      : context.translate('read_more'),
                                ),
                              ),
                          ],
                        ),
                      const SizedBox(height: 16),
                      if (artist.placeOfBirth != null && artist.placeOfBirth!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${context.translate('place_of_birth')}: ${artist.placeOfBirth}',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      if (artist.birthday != null && artist.birthday!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(Icons.cake, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${context.translate('birthday')}: ${artist.birthday}',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),
                      ArtistMoviesSection(artistAllMoviesAsync: artistAllMoviesAsync),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(context.translate('error_loading_artist_details'),
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(error.toString(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
