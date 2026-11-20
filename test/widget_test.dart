import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/theme/app_theme.dart';
import 'package:flutter_movie_clean_architecture/core/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatDuration', () {
    test('formats minutes into hours and minutes', () {
      expect(formatDuration(130), '2h 10m');
      expect(formatDuration(45), '0h 45m');
      expect(formatDuration(60), '1h 0m');
    });
  });

  group('formatTvDuration', () {
    test('returns N/A when runtime is missing', () {
      expect(formatTvDuration(null), 'N/A');
      expect(formatTvDuration(const []), 'N/A');
    });

    test('returns the average episode runtime', () {
      expect(formatTvDuration(const [30, 40, 50]), '40m');
    });
  });

  group('AppTheme', () {
    test('exposes light and dark themes', () {
      expect(AppTheme.lightTheme.brightness, Brightness.light);
      expect(AppTheme.darkTheme.brightness, Brightness.dark);
    });
  });
}
