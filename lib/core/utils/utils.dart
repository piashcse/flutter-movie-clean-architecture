/// Formats a movie runtime (in minutes) as `2h 10m`.
String formatDuration(int minutes) {
  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;
  return '${hours}h ${remainingMinutes}m';
}

/// Average episode runtime for a TV series, or `null` when TMDB has none.
String? formatTvDuration(List<int>? episodeRunTime) {
  if (episodeRunTime == null || episodeRunTime.isEmpty) {
    return null;
  }

  final average =
      episodeRunTime.reduce((a, b) => a + b) ~/ episodeRunTime.length;
  return '${average}m';
}
