import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/widgets/movie_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieHomePage extends ConsumerWidget {
  const MovieHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(nowPlayingMoviesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Now Playing')),
      body: moviesAsync.when(
        data: (movies) => GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2/3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) =>
              MovieCard(movie: movies[index]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}