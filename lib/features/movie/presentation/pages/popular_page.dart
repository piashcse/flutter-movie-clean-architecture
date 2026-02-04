import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/widgets/movie_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularPage extends ConsumerWidget {
  const PopularPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(popularMoviesProvider(1)); // Initially load first page

    return moviesAsync.when(
      data: (movies) {
        return RefreshIndicator(
          onRefresh: () async {
            // Refresh by reloading the provider
            await ref.refresh(popularMoviesProvider(1).future);
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return MovieCardWidget(movie: movies[index]);
            },
          ),
        );
      },
      error: (error, stack) => Center(child: Text('Error: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}