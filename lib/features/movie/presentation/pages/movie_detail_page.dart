import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MovieDetailPage extends StatelessWidget {
  final int movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Detail'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Text('Movie Detail for ID: $movieId'),
      ),
    );
  }
}