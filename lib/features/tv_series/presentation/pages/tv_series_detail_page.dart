import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/providers/tv_series_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TvSeriesDetailPage extends ConsumerWidget {
  final int tvSeriesId;

  const TvSeriesDetailPage({super.key, required this.tvSeriesId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tvSeriesDetailAsync = ref.watch(tvSeriesDetailProvider(tvSeriesId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Series Detail'),
      ),
      body: tvSeriesDetailAsync.when(
        data: (tvSeriesDetail) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tvSeriesDetail.posterPath != null
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w500${tvSeriesDetail.posterPath}',
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 300,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.movie,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tvSeriesDetail.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'First Air Date: ${tvSeriesDetail.firstAirDate}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rating: ${tvSeriesDetail.voteAverage.toStringAsFixed(1)}/10',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tvSeriesDetail.overview,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}