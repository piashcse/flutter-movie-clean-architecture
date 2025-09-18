import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/hive/favorite_model.dart';
import 'package:flutter_movie_clean_architecture/core/hive/hive_helper.dart';
import 'package:flutter_movie_clean_architecture/core/utils/utils.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/data/models/tv_series_credit_model.dart';
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
    final recommendedTvSeriesAsync = ref.watch(
      recommendedTvSeriesProvider(tvSeriesId),
    );
    final tvSeriesCreditsAsync = ref.watch(tvSeriesCreditsProvider(tvSeriesId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: tvSeriesDetailAsync.when(
        data: (tvSeries) => CustomScrollView(
          slivers: [
            TvSeriesDetailHeader(tvSeries: tvSeries),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  TvSeriesDetailInfoSection(tvSeries: tvSeries),
                  TvSeriesDescriptionSection(tvSeries: tvSeries),
                  RecommendedTvSeriesSection(
                    recommendedTvSeriesAsync: recommendedTvSeriesAsync,
                  ),
                  TvSeriesCastSection(
                    tvSeriesCreditsAsync: tvSeriesCreditsAsync,
                  ),
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
              Text(
                'Error loading TV series details',
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
    );
  }
}

class TvSeriesDetailHeader extends ConsumerStatefulWidget {
  final dynamic tvSeries;

  const TvSeriesDetailHeader({super.key, required this.tvSeries});

  @override
  ConsumerState<TvSeriesDetailHeader> createState() =>
      _TvSeriesDetailHeaderState();
}

class _TvSeriesDetailHeaderState extends ConsumerState<TvSeriesDetailHeader> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final isFavorite = await HiveHelper.isFavorite(widget.tvSeries.id, 'tv');
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      // Remove from favorites
      await HiveHelper.deleteFavorite(widget.tvSeries.id, 'tv');
    } else {
      // Add to favorites
      final favorite = Favorite(
        id: DateTime.now().millisecondsSinceEpoch,
        itemId: widget.tvSeries.id,
        title: widget.tvSeries.name ?? 'Unknown Title',
        posterPath: widget.tvSeries.posterPath ?? '',
        type: 'tv',
        overview: widget.tvSeries.overview,
        releaseDate: widget.tvSeries.firstAirDate,
      );
      await HiveHelper.insertFavorite(favorite);
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

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
        'TV Series Detail',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : Colors.white,
          ),
          onPressed: _toggleFavorite,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            widget.tvSeries.posterPath != null
                ? Image.network(
                    '$imageUrl${widget.tvSeries.posterPath}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.movie,
                        size: 64,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.movie,
                      size: 64,
                      color: Colors.grey,
                    ),
                  ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
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
              child: tvSeries.posterPath != null
                  ? Image.network(
                      '$imageUrl${tvSeries.posterPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
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
                      formatTvDuration(tvSeries.episodeRunTime),
                    ),
                    _buildInfoItem(
                      'First Air Date',
                      tvSeries.firstAirDate ?? 'N/A',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoItem(
                      'Language',
                      tvSeries.originalLanguage?.toUpperCase() ?? 'N/A',
                    ),
                    _buildInfoItem(
                      'Rating',
                      tvSeries.voteAverage?.toStringAsFixed(1) ?? 'N/A',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoItem(
                      'Episodes',
                      tvSeries.numberOfEpisodes?.toString() ?? 'N/A',
                    ),
                    _buildInfoItem(
                      'Seasons',
                      tvSeries.numberOfSeasons?.toString() ?? 'N/A',
                    ),
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
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class TvSeriesDescriptionSection extends ConsumerWidget {
  final dynamic tvSeries;

  const TvSeriesDescriptionSection({super.key, required this.tvSeries});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(tvDescriptionExpandedProvider);
    final overview = tvSeries.overview ?? 'No description available.';
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
            onTap: () =>
                ref.read(tvDescriptionExpandedProvider.notifier).state =
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

class RecommendedTvSeriesSection extends StatelessWidget {
  final AsyncValue<List<dynamic>> recommendedTvSeriesAsync;

  const RecommendedTvSeriesSection({
    super.key,
    required this.recommendedTvSeriesAsync,
  });

  @override
  Widget build(BuildContext context) {
    return recommendedTvSeriesAsync.when(
      data: (recommendedTvSeries) {
        if (recommendedTvSeries.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                'Recommended TV Series',
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
                itemCount: recommendedTvSeries.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final tvSeries = recommendedTvSeries[index];
                  return GestureDetector(
                    onTap: () => context.push('/tv/${tvSeries.id}'),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: tvSeries.posterPath != null
                          ? Image.network(
                              '$imageUrl${tvSeries.posterPath}',
                              width: 110,
                              height: 160,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _errorPlaceholder(),
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
          'Failed to load recommended TV series.',
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
      child: const Icon(Icons.tv, size: 48, color: Colors.grey),
    );
  }
}

class TvSeriesCastSection extends StatelessWidget {
  final AsyncValue<TvSeriesCreditModel> tvSeriesCreditsAsync;

  const TvSeriesCastSection({super.key, required this.tvSeriesCreditsAsync});

  @override
  Widget build(BuildContext context) {
    return tvSeriesCreditsAsync.when(
      data: (credits) {
        final castList = credits.cast ?? <Cast>[];
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
                separatorBuilder: (context, index) => const SizedBox(width: 4),
                itemBuilder: (context, index) {
                  final cast = castList[index];
                  final profileImageUrl = cast.profilePath != null
                      ? '$imageUrl${cast.profilePath}'
                      : null;

                  return GestureDetector(
                    onTap: () {
                      context.push('/artistId/${cast.id}');
                    },
                    child: SizedBox(
                      width: 80, // Fixed width for consistent layout
                      child: Column(
                        children: [
                          ClipOval(
                            child: profileImageUrl != null
                                ? Image.network(
                                    profileImageUrl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
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
          child: CircularProgressIndicator(color: Color(0xFF7B2CBF)),
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
