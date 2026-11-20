import 'package:flutter_movie_clean_architecture/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final entry in {
    'light': AppTheme.lightTheme,
    'dark': AppTheme.darkTheme,
  }.entries) {
    test('${entry.key} theme keeps tab labels readable on the app bar', () {
      final theme = entry.value;

      expect(theme.tabBarTheme.labelColor, theme.colorScheme.onPrimary);
      expect(theme.tabBarTheme.indicatorColor, theme.colorScheme.onPrimary);
      expect(theme.appBarTheme.backgroundColor, theme.colorScheme.primary);
    });
  }
}
