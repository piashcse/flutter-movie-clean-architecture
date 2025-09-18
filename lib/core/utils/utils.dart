String formatDuration(int minutes) {
  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;
  return '${hours}h ${remainingMinutes}m';
}

String formatTvDuration(List<int>? episodeRunTime) {
  if (episodeRunTime == null || episodeRunTime.isEmpty) {
    return 'N/A';
  }

  // For TV series, we'll show the average episode runtime
  final avgRuntime =
      episodeRunTime.reduce((a, b) => a + b) ~/ episodeRunTime.length;
  return '${avgRuntime}m';
}
