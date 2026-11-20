import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/core/utils/utils.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/app_status_views.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/credits_section.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/description_section.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/detail_header.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/detail_info_section.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/recommendations_section.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/domain/entities/favorite_item.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/presentation/favorite_actions.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie_detail.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_movie_clean_architecture/routing/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieDetailPage extends ConsumerWidget {
  const MovieDetailPage({super.key, required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(movieDetailProvider(movieId));
    final l10n = context.l10n;

    return Scaffold(
      body: detailAsync.when(
        data: (movie) => CustomScrollView(
          slivers: [
            DetailHeader(
              title: l10n.movieDetail,
              imageUrl: detailImage(movie.posterPath),
              isFavorite: isFavorite(ref, movie.id, FavoriteType.movie),
              onToggleFavorite: () =>
                  toggleFavorite(context, ref, _toFavorite(movie)),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailInfoSection(
                    title: movie.title,
                    imageUrl: tmdbImage(movie.posterPath),
                    items: [
                      DetailInfoItem(
                        l10n.duration,
                        movie.runtime > 0
                            ? formatDuration(movie.runtime)
                            : l10n.nA,
                      ),
                      DetailInfoItem(
                        l10n.releaseDate,
                        movie.releaseDate.isEmpty ? l10n.nA : movie.releaseDate,
                      ),
                      DetailInfoItem(
                        l10n.language,
                        movie.originalLanguage.isEmpty
                            ? l10n.nA
                            : movie.originalLanguage.toUpperCase(),
                      ),
                      DetailInfoItem(
                        l10n.rating,
                        movie.voteAverage > 0
                            ? movie.voteAverage.toStringAsFixed(1)
                            : l10n.nA,
                      ),
                    ],
                  ),
                  DescriptionSection(
                    title: l10n.description,
                    text: movie.overview,
                  ),
                  RecommendationsSection<Movie>(
                    itemsAsync: ref.watch(recommendedMoviesProvider(movieId)),
                    title: l10n.recommendedMovies,
                    errorText: l10n.failedToLoadRecommendedMovies,
                    imageOf: (item) => item.posterPath,
                    routeOf: (item) => AppRoutes.movie(item.id),
                    itemLabelOf: (item) => item.title,
                    onRetry: () =>
                        ref.invalidate(recommendedMoviesProvider(movieId)),
                  ),
                  CreditsSection(
                    creditsAsync: ref.watch(movieCreditsProvider(movieId)),
                    onRetry: () =>
                        ref.invalidate(movieCreditsProvider(movieId)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
        loading: AppLoadingView.new,
        error: (error, _) => AppErrorView(
          error: error,
          onRetry: () => ref.invalidate(movieDetailProvider(movieId)),
        ),
      ),
    );
  }

  FavoriteItem _toFavorite(MovieDetail movie) => FavoriteItem(
    itemId: movie.id,
    title: movie.title,
    posterPath: movie.posterPath ?? '',
    type: FavoriteType.movie,
    overview: movie.overview,
    releaseDate: movie.releaseDate,
  );
}
