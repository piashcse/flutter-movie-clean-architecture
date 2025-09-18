import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/utils/pagination_consumer_state.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/widgets/movie_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpComingPage extends ConsumerStatefulWidget {
  const UpComingPage({super.key});

  @override
  ConsumerState<UpComingPage> createState() => _UpComingMoviePageState();
}

class _UpComingMoviePageState extends PaginationConsumerState<Movie, UpComingPage> {
  @override
  Future<List<Movie>> fetchData(int page) async {
    return ref.read(upComingMoviesProvider(page).future);
  }

  @override
  Widget build(BuildContext context) {
    return buildContent(
      context: context,
      itemBuilder: (movie) => MovieCardWidget(movie: movie),
    );
  }
}