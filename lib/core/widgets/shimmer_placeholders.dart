import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/utils/layout.dart';
import 'package:shimmer/shimmer.dart';

/// Neutral block used inside skeleton layouts.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(borderRadius)
            : null,
      ),
    );
  }
}

/// Applies a single shimmer animation to an entire skeleton layout.
class ShimmerSkeleton extends StatelessWidget {
  const ShimmerSkeleton({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: colors.surfaceContainerHighest,
      highlightColor: colors.surfaceContainerLow,
      child: child,
    );
  }
}

/// Skeleton for a paginated poster grid.
class MediaGridSkeleton extends StatelessWidget {
  const MediaGridSkeleton({super.key, this.itemCount});

  final int? itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = gridColumnsForWidth(constraints.maxWidth);

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: itemCount ?? columns * 2,
            itemBuilder: (_, _) => const Column(
              children: [
                Expanded(child: SkeletonBox(borderRadius: 12)),
                SizedBox(height: 6),
                SkeletonBox(width: 72, height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Skeleton for the movie / TV detail screen.
class DetailSkeleton extends StatelessWidget {
  const DetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerSkeleton(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(height: 300, width: double.infinity, borderRadius: 0),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 120, height: 180, borderRadius: 12),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            SkeletonBox(height: 26, width: 200),
                            SizedBox(height: 16),
                            SkeletonBox(height: 14, width: double.infinity),
                            SizedBox(height: 10),
                            SkeletonBox(height: 14, width: 160),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  SkeletonBox(height: 20, width: 140),
                  SizedBox(height: 12),
                  SkeletonBox(height: 14, width: double.infinity),
                  SizedBox(height: 8),
                  SkeletonBox(height: 14, width: double.infinity),
                  SizedBox(height: 8),
                  SkeletonBox(height: 14, width: 240),
                  SizedBox(height: 24),
                  SkeletonBox(height: 20, width: 180),
                  SizedBox(height: 12),
                  _PosterRowSkeleton(count: 3),
                  SizedBox(height: 24),
                  SkeletonBox(height: 20, width: 100),
                  SizedBox(height: 12),
                  _CastRowSkeleton(count: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for a horizontal recommendations strip.
class HorizontalMediaSkeleton extends StatelessWidget {
  const HorizontalMediaSkeleton({
    super.key,
    this.height = 170,
    this.width = 110,
    this.itemCount = 4,
  });

  final double height;
  final double width;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SkeletonBox(height: 20, width: 160),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: height,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: itemCount,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, _) =>
                  SkeletonBox(width: width, height: height, borderRadius: 12),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

/// Skeleton for the cast carousel.
class CreditsSkeleton extends StatelessWidget {
  const CreditsSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SkeletonBox(height: 20, width: 100),
          ),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: itemCount,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, _) => const SizedBox(
                width: 80,
                child: Column(
                  children: [
                    SkeletonBox(width: 70, height: 70, shape: BoxShape.circle),
                    SizedBox(height: 8),
                    SkeletonBox(width: 56, height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton rows for universal-search results.
class SearchResultsSkeleton extends StatelessWidget {
  const SearchResultsSkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: Column(
        children: [
          for (var index = 0; index < itemCount; index++)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  SkeletonBox(width: 48, height: 64, borderRadius: 6),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(height: 14, width: double.infinity),
                        SizedBox(height: 8),
                        SkeletonBox(height: 12, width: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Skeleton used as the grid pagination footer.
class MediaCardSkeleton extends StatelessWidget {
  const MediaCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerSkeleton(child: SkeletonBox(borderRadius: 12));
  }
}

class _PosterRowSkeleton extends StatelessWidget {
  const _PosterRowSkeleton({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, _) =>
            const SkeletonBox(width: 110, height: 160, borderRadius: 12),
      ),
    );
  }
}

class _CastRowSkeleton extends StatelessWidget {
  const _CastRowSkeleton({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, _) => const Column(
          children: [
            SkeletonBox(width: 70, height: 70, shape: BoxShape.circle),
            SizedBox(height: 8),
            SkeletonBox(width: 56, height: 10),
          ],
        ),
      ),
    );
  }
}
