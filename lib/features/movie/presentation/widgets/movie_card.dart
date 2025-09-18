import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:go_router/go_router.dart';

class MovieCardWidget extends StatelessWidget {
  final Movie movie;

  const MovieCardWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/movie/${movie.id}');
      },
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                12,
              ), // Adjust radius as needed
              child: CachedNetworkImage(
                imageUrl: '$imageUrl${movie.posterPath}',
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
