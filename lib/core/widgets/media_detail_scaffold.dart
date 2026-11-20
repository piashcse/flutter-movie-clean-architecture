import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/app_status_views.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/shimmer_placeholders.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Scaffolds the common detail-page states (loading, error, data) around a
/// CustomScrollView built by [builder].
class MediaDetailScaffold<T> extends StatelessWidget {
  const MediaDetailScaffold({
    super.key,
    required this.detailAsync,
    required this.onRetry,
    required this.builder,
  });

  final AsyncValue<T> detailAsync;
  final VoidCallback onRetry;
  final Widget Function(BuildContext context, T data) builder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: detailAsync.when(
        data: (data) => builder(context, data),
        loading: DetailSkeleton.new,
        error: (error, _) => AppErrorView(error: error, onRetry: onRetry),
      ),
    );
  }
}
