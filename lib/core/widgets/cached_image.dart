import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final bool isCircular;
  final IconData errorIcon;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.isCircular = false,
    this.errorIcon = Icons.broken_image,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = shimmerBaseColor ?? Colors.grey[300]!;
    final highlightColor = shimmerHighlightColor ?? Colors.grey[100]!;

    Widget imageWidget;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, _) => _shimmerPlaceholder(baseColor, highlightColor),
        errorWidget: (_, _, _) => _staticPlaceholder(baseColor),
      );
    } else {
      imageWidget = _staticPlaceholder(baseColor);
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
      child: Container(
        width: width,
        height: height,
        color: base,
      ),
    );
  }

  Widget _staticPlaceholder(Color base) {
    return Container(
      width: width,
      height: height,
      color: base,
      child: Icon(errorIcon, color: Colors.grey),
    );
  }
}
