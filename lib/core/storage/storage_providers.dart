import 'package:flutter_movie_clean_architecture/core/hive/hive_helper.dart';
import 'package:flutter_movie_clean_architecture/core/storage/key_value_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Key/value store backed by the Hive `settings` box.
///
/// Override this provider in tests with an in-memory implementation.
final settingsStoreProvider = Provider<KeyValueStore>(
  (ref) => HiveKeyValueStore(HiveHelper.settingsBoxName),
);
