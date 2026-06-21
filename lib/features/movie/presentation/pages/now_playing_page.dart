import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/utils/pagination_consumer_state.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/media_card.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NowPlayingPage extends ConsumerStatefulWidget {
  const NowPlayingPage({super.key});

  @override
  ConsumerState<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends PaginationConsumerState<Movie, NowPlayingPage> {
  @override
  Future<List<Movie>> fetchData(int page) async {
    return ref.read(nowPlayingMoviesProvider(page).future);
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
