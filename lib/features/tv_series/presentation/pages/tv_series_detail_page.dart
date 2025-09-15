import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/utils/utils.dart';
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
              Text('Error loading TV series details',
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

class TvSeriesDetailHeader extends StatelessWidget {
  final dynamic tvSeries;

  const TvSeriesDetailHeader({super.key, required this.tvSeries});

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
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            tvSeries.posterPath != null
                ? Image.network(
                    '$IMAGE_URL${tvSeries.posterPath}',
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
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: tvSeries.posterPath != null
                  ? Image.network(
                      '$IMAGE_URL${tvSeries.posterPath}',
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
            onTap: () => ref.read(tvDescriptionExpandedProvider.notifier).state =
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