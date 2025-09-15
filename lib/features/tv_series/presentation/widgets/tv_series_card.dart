import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series.dart';
import 'package:go_router/go_router.dart';

class TvSeriesCardWidget extends StatelessWidget {
  final TvSeries tvSeries;

  const TvSeriesCardWidget({super.key, required this.tvSeries});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/tv/${tvSeries.id}');
      },
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12), // Match movie card radius
              child: CachedNetworkImage(
                imageUrl: '$IMAGE_URL${tvSeries.posterPath}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}