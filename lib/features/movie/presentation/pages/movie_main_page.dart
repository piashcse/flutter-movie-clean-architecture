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

    MediaHubTab tab(String label, IconData icon, PageFetcher<Movie> fetchPage) {
      return MediaHubTab(
        label: label,
        icon: icon,
        page: PagedMediaGrid<Movie>(
          fetchPage: fetchPage,
          itemBuilder: (context, movie) => MediaCard(
            imagePath: movie.posterPath,
            title: movie.title,
            onTap: () => context.push(AppRoutes.movie(movie.id)),
          ),
        ),
      );
    }

    return MediaHubPage(
      tabs: [
        tab(
          l10n.nowPlaying,
          Icons.play_circle_fill,
          (ref, page) => ref.read(nowPlayingMoviesProvider(page).future),
        ),
        tab(
          l10n.popular,
          Icons.favorite,
          (ref, page) => ref.read(popularMoviesProvider(page).future),
        ),
        tab(
          l10n.topRated,
          Icons.star,
          (ref, page) => ref.read(topRatedMoviesProvider(page).future),
        ),
        tab(
          l10n.upcoming,
          Icons.upcoming,
          (ref, page) => ref.read(upcomingMoviesProvider(page).future),
        ),
      ],
    );
  }
}
