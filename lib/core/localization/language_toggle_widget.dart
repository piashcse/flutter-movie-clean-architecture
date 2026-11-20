import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/core/localization/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageToggleWidget extends ConsumerWidget {
  const LanguageToggleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final l10n = context.l10n;

    return PopupMenuButton<String>(
      tooltip: l10n.languageLabel,
      icon: const Icon(Icons.translate),
      initialValue: locale?.languageCode ?? 'system',
      onSelected: (value) => ref
          .read(localeProvider.notifier)
          .setLocale(value == 'system' ? null : Locale(value)),
      itemBuilder: (context) => [
        PopupMenuItem<String>(value: 'system', child: Text(l10n.systemDefault)),
        const PopupMenuItem<String>(value: 'en', child: Text('English')),
        const PopupMenuItem<String>(value: 'es', child: Text('Español')),
      ],
    );
  }
}
