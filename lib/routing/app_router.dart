import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/artist_detail_page.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/movie_detail_page.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter_movie_clean_architecture/presentation/pages/main_tab_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const MainTabPage()),
    GoRoute(
      path: '/movie/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return MovieDetailPage(movieId: id);
      },
    ),
    GoRoute(
      path: '/artistId/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ArtistDetailPage(artistId: id);
      },
    ),
    GoRoute(
      path: '/tv/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return TvSeriesDetailPage(tvSeriesId: id);
      },
    ),
  ],
);
