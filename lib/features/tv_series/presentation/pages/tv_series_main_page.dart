import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/media_card.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/media_hub_page.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/paged_media_grid.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/providers/tv_series_provider.dart';
import 'package:flutter_movie_clean_architecture/routing/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TvSeriesMainPage extends ConsumerWidget {
  const TvSeriesMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    MediaHubTab tab(
      String label,
      IconData icon,
      PageFetcher<TvSeries> fetchPage,
    ) {
      return MediaHubTab(
        label: label,
        icon: icon,
        page: PagedMediaGrid<TvSeries>(
          fetchPage: fetchPage,
          itemBuilder: (context, series) => MediaCard(
            imagePath: series.posterPath,
            title: series.name,
            onTap: () => context.push(AppRoutes.tv(series.id)),
          ),
        ),
      );
    }

    return MediaHubPage(
      tabs: [
        tab(
          l10n.airingToday,
          Icons.today,
          (ref, page) => ref.read(airingTodayTvSeriesProvider(page).future),
        ),
        tab(
          l10n.onTheAir,
          Icons.live_tv,
          (ref, page) => ref.read(onTheAirTvSeriesProvider(page).future),
        ),
        tab(
          l10n.popular,
          Icons.favorite,
          (ref, page) => ref.read(popularTvSeriesProvider(page).future),
        ),
        tab(
          l10n.upcoming,
          Icons.upcoming,
          (ref, page) => ref.read(upcomingTvSeriesProvider(page).future),
        ),
      ],
    );
  }
}
