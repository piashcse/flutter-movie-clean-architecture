import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_provider.dart';

class ThemeToggleWidget extends ConsumerWidget {
  const ThemeToggleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return PopupMenuButton<ThemeMode>(
      icon: Icon(
        themeMode == ThemeMode.dark 
          ? Icons.dark_mode 
          : (themeMode == ThemeMode.light 
              ? Icons.light_mode 
              : Icons.brightness_auto),
      ),
      onSelected: (ThemeMode mode) {
        ref.read(themeModeProvider.notifier).state = mode;
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeMode>>[
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.system,
          child: Row(
            children: [
              Icon(
                Icons.brightness_auto,
                color: themeMode == ThemeMode.system ? Theme.of(context).primaryColor : null,
              ),
              const SizedBox(width: 12),
              const Text('System'),
            ],
          ),
        ),
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.light,
          child: Row(
            children: [
              Icon(
                Icons.light_mode,
                color: themeMode == ThemeMode.light ? Theme.of(context).primaryColor : null,
              ),
              const SizedBox(width: 12),
              const Text('Light'),
            ],
          ),
        ),
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.dark,
          child: Row(
            children: [
              Icon(
                Icons.dark_mode,
                color: themeMode == ThemeMode.dark ? Theme.of(context).primaryColor : null,
              ),
              const SizedBox(width: 12),
              const Text('Dark'),
            ],
          ),
        ),
      ],
    );
  }
}