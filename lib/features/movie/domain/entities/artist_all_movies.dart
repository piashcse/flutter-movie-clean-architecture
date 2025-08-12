import 'package:flutter_movie_clean_architecture/features/movie/data/models/movie_model.dart';

class Artistallmovies {
  final int id;
  final List<MovieModel> cast;

  Artistallmovies({
    required this.id,
    required this.cast,
  });
}
