import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.isCircular = false,
    this.errorIcon = Icons.broken_image,
    this.semanticLabel,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final bool isCircular;
  final IconData errorIcon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    Widget imageWidget;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, _) => _shimmerPlaceholder(
          colors.surfaceContainerHighest,
          colors.surfaceContainerLow,
        ),
        errorWidget: (_, _, _) => _staticPlaceholder(colors),
        imageBuilder: (context, imageProvider) => Image(
          image: imageProvider,
          width: width,
          height: height,
          fit: fit,
          semanticLabel: semanticLabel,
        ),
      );
    } else {
      imageWidget = _staticPlaceholder(colors);
    }

    if (isCircular) {
      return ClipOval(child: imageWidget);
    }
    if (borderRadius > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: imageWidget,
      );
    }
    return imageWidget;
  }

  Widget _shimmerPlaceholder(Color base, Color highlight) {
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: SizedBox(width: width, height: height),
    );
  }

  Widget _staticPlaceholder(ColorScheme colors) {
    return Container(
      width: width,
      height: height,
      color: colors.surfaceContainerHighest,
      child: Icon(errorIcon, color: colors.outline),
    );
  }
}
