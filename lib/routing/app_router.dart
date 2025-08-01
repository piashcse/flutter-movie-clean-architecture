import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/movie_detail_page.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/movie_main_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const MovieMainPage(),
    ),
    GoRoute(
      path: '/movie/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return MovieDetailPage(movieId: id);
      },
    ),
  ],
);