import '../repository/theme_repository.dart';

class ToggleThemeMode {
  final ThemeRepository repository;

  ToggleThemeMode(this.repository);

  Future<void> call() => repository.toggleThemeMode();
}