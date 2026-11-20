import 'package:hive/hive.dart';

/// Abstraction over simple key/value persistence so presentation code never
/// talks to Hive directly.
abstract interface class KeyValueStore {
  String? read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);
}

class HiveKeyValueStore implements KeyValueStore {
  HiveKeyValueStore(this._boxName);

  final String _boxName;

  Box<dynamic> get _box => Hive.box<dynamic>(_boxName);

  @override
  String? read(String key) {
    try {
      return _box.get(key) as String?;
    } on HiveError {
      return null;
    }
  }

  @override
  Future<void> write(String key, String value) => _box.put(key, value);

  @override
  Future<void> delete(String key) => _box.delete(key);
}
