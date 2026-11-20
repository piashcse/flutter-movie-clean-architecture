import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/media_card.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/media_hub_page.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/paged_media_grid.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_movie_clean_architecture/routing/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieMainPage extends ConsumerWidget {
  const MovieMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return MediaHubPage(
      tabs: [
        MediaHubTab(
          label: l10n.nowPlaying,
          icon: Icons.play_circle_fill,
          page: _MovieGrid(
            fetchPage: (ref, page) =>
                ref.read(nowPlayingMoviesProvider(page).future),
          ),
        ),
        MediaHubTab(
          label: l10n.popular,
          icon: Icons.favorite,
          page: _MovieGrid(
            fetchPage: (ref, page) =>
                ref.read(popularMoviesProvider(page).future),
          ),
        ),
        MediaHubTab(
          label: l10n.topRated,
          icon: Icons.star,
          page: _MovieGrid(
            fetchPage: (ref, page) =>
                ref.read(topRatedMoviesProvider(page).future),
          ),
        ),
        MediaHubTab(
          label: l10n.upcoming,
          icon: Icons.upcoming,
          page: _MovieGrid(
            fetchPage: (ref, page) =>
                ref.read(upcomingMoviesProvider(page).future),
          ),
        ),
      ],
    );
  }
}

class _MovieGrid extends StatelessWidget {
  const _MovieGrid({required this.fetchPage});

  final Future<List<Movie>> Function(WidgetRef ref, int page) fetchPage;

  @override
  Widget build(BuildContext context) {
    return PagedMediaGrid<Movie>(
      fetchPage: fetchPage,
      itemBuilder: (context, movie) => MediaCard(
        imagePath: movie.posterPath,
        title: movie.title,
        onTap: () => context.push(AppRoutes.movie(movie.id)),
      ),
    );
  }
}
