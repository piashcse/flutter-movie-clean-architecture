import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/cached_image.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({
    super.key,
    required this.imagePath,
    required this.onTap,
    this.title,
    this.isPerson = false,
  });

  final String? imagePath;
  final String? title;
  final VoidCallback onTap;
  final bool isPerson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: title,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: CachedImage(
                  imageUrl: tmdbImage(imagePath),
                  borderRadius: 12,
                  errorIcon: isPerson ? Icons.person : Icons.movie,
                  semanticLabel: title,
                ),
              ),
            ),
            if (title != null) ...[
              const SizedBox(height: 4),
              Text(
                title!,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
