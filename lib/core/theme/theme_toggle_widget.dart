import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/core/theme/theme_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggleWidget extends ConsumerWidget {
  const ThemeToggleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final l10n = context.l10n;

    return PopupMenuButton<ThemeMode>(
      tooltip: l10n.theme,
      icon: Icon(switch (themeMode) {
        ThemeMode.dark => Icons.dark_mode,
        ThemeMode.light => Icons.light_mode,
        ThemeMode.system => Icons.brightness_auto,
      }),
      initialValue: themeMode,
      onSelected: (mode) => ref.read(themeModeProvider.notifier).setTheme(mode),
      itemBuilder: (context) => [
        _entry(
          context,
          themeMode,
          ThemeMode.system,
          Icons.brightness_auto,
          l10n.themeSystem,
        ),
        _entry(
          context,
          themeMode,
          ThemeMode.light,
          Icons.light_mode,
          l10n.themeLight,
        ),
        _entry(
          context,
          themeMode,
          ThemeMode.dark,
          Icons.dark_mode,
          l10n.themeDark,
        ),
      ],
    );
  }

  PopupMenuItem<ThemeMode> _entry(
    BuildContext context,
    ThemeMode current,
    ThemeMode mode,
    IconData icon,
    String label,
  ) {
    final isSelected = current == mode;

    return PopupMenuItem<ThemeMode>(
      value: mode,
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? Theme.of(context).colorScheme.primary : null,
          ),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }
}
