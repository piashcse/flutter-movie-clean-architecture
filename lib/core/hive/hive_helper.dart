import 'package:flutter_movie_clean_architecture/features/favorites/data/models/favorite_adapter.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/data/models/favorite_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Owns Hive initialisation and box lifecycles.
class HiveHelper {
  static const String favoritesBoxName = 'favorites_box';
  static const String settingsBoxName = 'settings';

  static Box<Favorite>? _favoritesBox;
  static Box<dynamic>? _settingsBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(FavoriteAdapter());
    }

    _favoritesBox = await Hive.openBox<Favorite>(favoritesBoxName);
    _settingsBox = await Hive.openBox<dynamic>(settingsBoxName);
  }

  static Box<Favorite> get favoritesBox {
    final box = _favoritesBox;
    if (box == null) {
      throw StateError(
        'HiveHelper.init() must be called before accessing boxes.',
      );
    }
    return box;
  }

  static Future<void> close() async {
    await _favoritesBox?.close();
    await _settingsBox?.close();
    _favoritesBox = null;
    _settingsBox = null;
  }
}
