import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/utils/pagination_consumer_state.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/widgets/movie_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularPage extends ConsumerStatefulWidget {
  const PopularPage({super.key});

  @override
  ConsumerState<PopularPage> createState() => _PopularMoviePageState();
}

class _PopularMoviePageState
    extends PaginationConsumerState<Movie, PopularPage> {
  @override
  Future<List<Movie>> fetchData(int page) async {
    return ref.read(popularMoviesProvider(page).future);
  }

  @override
  Widget build(BuildContext context) {
    return buildContent(
      context: context,
      itemBuilder: (movie) => MovieCardWidget(movie: movie),
    );
  }
}
