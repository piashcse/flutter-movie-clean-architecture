class TvSeriesDetail {
  final int id;
  final String name;
  final String? posterPath;
  final String overview;
  final double voteAverage;
  final String firstAirDate;
  final String? originalLanguage;
  final List<int>? episodeRunTime;
  final String? lastAirDate;
  final int? numberOfEpisodes;
  final int? numberOfSeasons;

  TvSeriesDetail({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.firstAirDate,
    this.originalLanguage,
    this.episodeRunTime,
    this.lastAirDate,
    this.numberOfEpisodes,
    this.numberOfSeasons,
  });
}
