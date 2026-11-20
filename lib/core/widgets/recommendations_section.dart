import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/cached_image.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/inline_error.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/shimmer_placeholders.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Horizontally scrolling recommendations strip.
///
/// Generic over [T] so movie, TV and combined-credit results all share it
/// without `dynamic` callbacks.
class RecommendationsSection<T> extends StatelessWidget {
  const RecommendationsSection({
    super.key,
    required this.itemsAsync,
    required this.title,
    required this.errorText,
    required this.imageOf,
    required this.routeOf,
    this.onRetry,
    this.itemLabelOf,
    this.fallbackIcon = Icons.movie_outlined,
  });

  final AsyncValue<List<T>> itemsAsync;
  final String title;
  final String errorText;
  final String? Function(T item) imageOf;
  final String Function(T item) routeOf;
  final String? Function(T item)? itemLabelOf;
  final VoidCallback? onRetry;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    return itemsAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(title),
            SizedBox(
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final label = itemLabelOf?.call(item);

                  return Semantics(
                    button: true,
                    label: label,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => context.push(routeOf(item)),
                      child: CachedImage(
                        imageUrl: tmdbImage(imageOf(item)),
                        width: 110,
                        height: 160,
                        borderRadius: 12,
                        errorIcon: fallbackIcon,
                        semanticLabel: label,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        );
      },
      loading: HorizontalMediaSkeleton.new,
      error: (error, _) => InlineError(message: errorText, onRetry: onRetry),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
