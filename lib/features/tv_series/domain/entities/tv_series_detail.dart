class TvSeriesDetail {
  final int id;
  final String name;
  final String? posterPath;
  final String overview;
  final double voteAverage;
  final String firstAirDate;

  TvSeriesDetail({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.firstAirDate,
  });
}