import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/utils/pagination_consumer_state.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/media_card.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PopularPage extends ConsumerStatefulWidget {
  const PopularPage({super.key});

  @override
  ConsumerState<PopularPage> createState() => _PopularPageState();
}

class _PopularPageState extends PaginationConsumerState<Movie, PopularPage> {
  @override
  Future<List<Movie>> fetchData(int page) async {
    return ref.read(popularMoviesProvider(page).future);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: buildContent(
        context: context,
        itemBuilder: (movie) => MediaCard(
          imagePath: movie.posterPath,
          onTap: () => context.push('/movie/${movie.id}'),
        ),
      ),
    );
  }
}
