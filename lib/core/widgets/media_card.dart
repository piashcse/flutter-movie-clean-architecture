import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';

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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imagePath != null
                  ? CachedNetworkImage(
                      imageUrl: '$imageUrl$imagePath',
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => _placeholder(context),
                    )
                  : _placeholder(context),
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

  Widget _placeholder(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        isPerson ? Icons.person : Icons.movie,
        color: Colors.grey,
        size: 40,
      ),
    );
  }
}
