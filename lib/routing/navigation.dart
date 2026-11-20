import 'package:flutter/widgets.dart';
import 'package:flutter_movie_clean_architecture/routing/app_routes.dart';
import 'package:go_router/go_router.dart';

/// Pops the current route, or falls back to the home tab when there is no
/// history (for example when a detail screen is opened from a deep link).
void popOrGoHome(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(AppRoutes.home);
  }
}
