import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/artist_detail_page.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/movie_detail_page.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter_movie_clean_architecture/presentation/pages/main_tab_page.dart';
import 'package:flutter_movie_clean_architecture/routing/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (context, state) => const MainTabPage(),
      ),
      GoRoute(
        path: AppRoutes.moviePattern,
        name: AppRoutes.movieName,
        builder: (context, state) => MovieDetailPage(movieId: _idFrom(state)),
      ),
      GoRoute(
        path: AppRoutes.tvPattern,
        name: AppRoutes.tvName,
        builder: (context, state) =>
            TvSeriesDetailPage(tvSeriesId: _idFrom(state)),
      ),
      GoRoute(
        path: AppRoutes.artistPattern,
        name: AppRoutes.artistName,
        builder: (context, state) => ArtistDetailPage(artistId: _idFrom(state)),
      ),
    ],
    errorBuilder: (context, state) => _RouteErrorPage(error: state.error),
  );
});

int _idFrom(GoRouterState state) =>
    int.tryParse(state.pathParameters[AppRoutes.idParam] ?? '') ?? 0;

class _RouteErrorPage extends StatelessWidget {
  const _RouteErrorPage({this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.errorTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.explore_off_outlined,
                size: 56,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.errorNotFound,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              FilledButton.tonalIcon(
                onPressed: () => context.go(AppRoutes.home),
                icon: const Icon(Icons.home_outlined),
                label: Text(context.l10n.backToHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
