class MovieDetail {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;
  final int runtime;
  final String originalLanguage;
  final List<String> genres;
  final List<String> productionCompanies;

  MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.runtime,
    required this.originalLanguage,
    required this.genres,
    required this.productionCompanies,
  });
}
