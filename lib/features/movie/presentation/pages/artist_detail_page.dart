import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/hive/favorite_model.dart';
import 'package:flutter_movie_clean_architecture/core/hive/hive_helper.dart';
import 'package:flutter_movie_clean_architecture/core/localization/localization_helper.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ArtistDetailPage extends ConsumerStatefulWidget {
  final int artistId;

  const ArtistDetailPage({super.key, required this.artistId});

  @override
  ConsumerState<ArtistDetailPage> createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends ConsumerState<ArtistDetailPage> {
  bool _isExpanded = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final isFavorite = await HiveHelper.isFavorite(widget.artistId, 'celebrity');
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  Future<void> _toggleFavorite(dynamic artist) async {
    if (_isFavorite) {
      // Remove from favorites
      await HiveHelper.deleteFavorite(widget.artistId, 'celebrity');
    } else {
      // Add to favorites
      final favorite = Favorite(
        id: DateTime.now().millisecondsSinceEpoch,
        itemId: widget.artistId,
        title: artist.name ?? 'Unknown Artist',
        posterPath: artist.profilePath ?? '',
        type: 'celebrity',
        overview: artist.biography,
        releaseDate: null,
      );
      await HiveHelper.insertFavorite(favorite);
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final artistDetailAsync = ref.watch(artistDetailProvider(widget.artistId));
    final artistAllMoviesAsync = ref.watch(artistDetailAllMoviesProvider(widget.artistId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: artistDetailAsync.when(
        data: (artist) => CustomScrollView(
          slivers: [
            // Silver AppBar
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Colors.black,
              elevation: 0,
              pinned: true,
              floating: false,
              expandedHeight: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
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
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.black,
                  ),
                  onPressed: () => _toggleFavorite(artist),
                ),
              ],
            ),
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Artist Profile Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 140,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: artist.profilePath != null
                                ? DecorationImage(
                              image: NetworkImage("$IMAGE_URL${artist.profilePath}"),
                              fit: BoxFit.cover,
                            )
                                : null,
                            color: artist.profilePath == null ? Colors.grey[300] : null,
                          ),
                          child: artist.profilePath == null
                              ? const Icon(Icons.person, color: Colors.grey, size: 60)
                              : null,
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
                              const SizedBox(height: 8),
                              Text(
                                context.translate('birthday'),
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                              Text(
                                artist.birthday ?? context.translate('n_a'),
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                context.translate('place_of_birth'),
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                              Text(
                                artist.placeOfBirth ?? context.translate('n_a'),
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Biography Section
                    Text(
            context.translate('biography'),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
                    const SizedBox(height: 12),
                    Text(
                        artist.biography ?? context.translate('no_biography_available'),
                        maxLines: _isExpanded ? null : 4,
                        overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                      ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Text(
                        _isExpanded ? context.translate('show_less') : context.translate('show_more'),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.cyan,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Artist Movies Section
                    ArtistMoviesSection(artistAllMoviesAsync: artistAllMoviesAsync),
                  ],
                ),
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
              Text(context.translate('error_loading_artist_details'),
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey)),
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

class ArtistMoviesSection extends StatelessWidget {
  final AsyncValue<dynamic> artistAllMoviesAsync; // expecting API response

  const ArtistMoviesSection({super.key, required this.artistAllMoviesAsync});

  @override
  Widget build(BuildContext context) {
    return artistAllMoviesAsync.when(
      data: (moviesResponse) {
        final movies = moviesResponse.cast; // cast list from API
        if (movies.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Text(
                context.translate('movies_and_tv_shows'),
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
                itemCount: movies.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = movies[index];
                  return GestureDetector(
                    onTap: () {
                      // Check if the item is a movie or TV series
                      if (item.mediaType == 'tv') {
                        context.push('/tv/${item.id}');
                      } else {
                        // Default to movie if mediaType is not specified or is 'movie'
                        context.push('/movie/${item.id}');
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: item.posterPath != null
                          ? Image.network(
                        '$IMAGE_URL${item.posterPath}',
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          context.translate('failed_to_load_movies'),
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