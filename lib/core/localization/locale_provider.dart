import 'package:flutter/widgets.dart';
import 'package:flutter_movie_clean_architecture/core/storage/storage_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const supportedLocaleCodes = <String>{'en', 'es'};

/// Currently selected locale. `null` means "follow the system locale".
final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale?> {
  static const _storageKey = 'locale';

  @override
  Locale? build() {
    final saved = ref.watch(settingsStoreProvider).read(_storageKey);
    if (saved == null || !supportedLocaleCodes.contains(saved)) {
      return null;
    }
    return Locale(saved);
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    final store = ref.read(settingsStoreProvider);

    if (locale == null) {
      await store.delete(_storageKey);
    } else {
      await store.write(_storageKey, locale.languageCode);
    }
  }
}
