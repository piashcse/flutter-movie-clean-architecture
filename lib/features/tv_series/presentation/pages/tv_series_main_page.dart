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

    return MediaHubPage(
      tabs: [
        MediaHubTab(
          label: l10n.airingToday,
          icon: Icons.today,
          page: _TvSeriesGrid(
            fetchPage: (ref, page) =>
                ref.read(airingTodayTvSeriesProvider(page).future),
          ),
        ),
        MediaHubTab(
          label: l10n.onTheAir,
          icon: Icons.live_tv,
          page: _TvSeriesGrid(
            fetchPage: (ref, page) =>
                ref.read(onTheAirTvSeriesProvider(page).future),
          ),
        ),
        MediaHubTab(
          label: l10n.popular,
          icon: Icons.favorite,
          page: _TvSeriesGrid(
            fetchPage: (ref, page) =>
                ref.read(popularTvSeriesProvider(page).future),
          ),
        ),
        MediaHubTab(
          label: l10n.upcoming,
          icon: Icons.upcoming,
          page: _TvSeriesGrid(
            fetchPage: (ref, page) =>
                ref.read(upcomingTvSeriesProvider(page).future),
          ),
        ),
      ],
    );
  }
}

class _TvSeriesGrid extends StatelessWidget {
  const _TvSeriesGrid({required this.fetchPage});

  final Future<List<TvSeries>> Function(WidgetRef ref, int page) fetchPage;

  @override
  Widget build(BuildContext context) {
    return PagedMediaGrid<TvSeries>(
      fetchPage: fetchPage,
      itemBuilder: (context, series) => MediaCard(
        imagePath: series.posterPath,
        title: series.name,
        onTap: () => context.push(AppRoutes.tv(series.id)),
      ),
    );
  }
}
