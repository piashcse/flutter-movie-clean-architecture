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
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/providers/tv_series_provider.dart';
import 'package:flutter_movie_clean_architecture/routing/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TvSeriesDetailPage extends ConsumerWidget {
  const TvSeriesDetailPage({super.key, required this.tvSeriesId});

  final int tvSeriesId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(tvSeriesDetailProvider(tvSeriesId));
    final l10n = context.l10n;

    return Scaffold(
      body: detailAsync.when(
        data: (series) => CustomScrollView(
          slivers: [
            DetailHeader(
              title: l10n.tvSeriesDetail,
              imageUrl: detailImage(series.posterPath),
              isFavorite: isFavorite(ref, series.id, FavoriteType.tv),
              onToggleFavorite: () =>
                  toggleFavorite(context, ref, _toFavorite(series)),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailInfoSection(
                    title: series.name,
                    imageUrl: tmdbImage(series.posterPath),
                    items: [
                      DetailInfoItem(
                        l10n.duration,
                        formatTvDuration(series.episodeRunTime) ?? l10n.nA,
                      ),
                      DetailInfoItem(
                        l10n.firstAirDate,
                        series.firstAirDate.isEmpty
                            ? l10n.nA
                            : series.firstAirDate,
                      ),
                      DetailInfoItem(
                        l10n.language,
                        series.originalLanguage.isEmpty
                            ? l10n.nA
                            : series.originalLanguage.toUpperCase(),
                      ),
                      DetailInfoItem(
                        l10n.rating,
                        series.voteAverage > 0
                            ? series.voteAverage.toStringAsFixed(1)
                            : l10n.nA,
                      ),
                      DetailInfoItem(
                        l10n.episodes,
                        series.numberOfEpisodes > 0
                            ? '${series.numberOfEpisodes}'
                            : l10n.nA,
                      ),
                      DetailInfoItem(
                        l10n.seasons,
                        series.numberOfSeasons > 0
                            ? '${series.numberOfSeasons}'
                            : l10n.nA,
                      ),
                    ],
                  ),
                  DescriptionSection(
                    title: l10n.description,
                    text: series.overview,
                  ),
                  RecommendationsSection<TvSeries>(
                    itemsAsync: ref.watch(
                      recommendedTvSeriesProvider(tvSeriesId),
                    ),
                    title: l10n.recommendedTvSeries,
                    errorText: l10n.failedToLoadRecommendedTvSeries,
                    imageOf: (item) => item.posterPath,
                    routeOf: (item) => AppRoutes.tv(item.id),
                    itemLabelOf: (item) => item.name,
                    fallbackIcon: Icons.tv,
                    onRetry: () =>
                        ref.invalidate(recommendedTvSeriesProvider(tvSeriesId)),
                  ),
                  CreditsSection(
                    creditsAsync: ref.watch(
                      tvSeriesCreditsProvider(tvSeriesId),
                    ),
                    onRetry: () =>
                        ref.invalidate(tvSeriesCreditsProvider(tvSeriesId)),
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
          onRetry: () => ref.invalidate(tvSeriesDetailProvider(tvSeriesId)),
        ),
      ),
    );
  }

  FavoriteItem _toFavorite(TvSeriesDetail series) => FavoriteItem(
    itemId: series.id,
    title: series.name,
    posterPath: series.posterPath ?? '',
    type: FavoriteType.tv,
    overview: series.overview,
    releaseDate: series.firstAirDate,
  );
}
