import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/cached_image.dart';

class MediaCard extends StatelessWidget {
  final String? imagePath;
  final String? title;
  final VoidCallback onTap;
  final bool isPerson;

  const MediaCard({
    super.key,
    required this.imagePath,
    this.title,
    required this.onTap,
    this.isPerson = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: CachedImage(
              imageUrl: imagePath != null ? '$imageUrl$imagePath' : null,
              fit: BoxFit.cover,
              borderRadius: 12,
              errorIcon: isPerson ? Icons.person : Icons.movie,
            ),
          ),
          if (title != null) ...[
            const SizedBox(height: 4),
            Text(
              title!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
