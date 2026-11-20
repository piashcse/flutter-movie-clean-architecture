import 'package:hive/hive.dart';

import 'favorite_model.dart';

/// Hand-written Hive adapter for [Favorite].
///
/// `hive_generator` is not compatible with the current `freezed`/`source_gen`
/// toolchain, so the adapter is maintained manually. Keep the field ids in
/// sync with the `@HiveField` annotations on [Favorite].
class FavoriteAdapter extends TypeAdapter<Favorite> {
  @override
  final int typeId = 0;

  @override
  Favorite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favorite(
      itemId: fields[1] as int,
      title: fields[2] as String,
      posterPath: fields[3] as String,
      type: fields[4] as String,
      overview: fields[5] as String?,
      releaseDate: fields[6] as String?,
    )..id = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, Favorite obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.itemId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.posterPath)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.overview)
      ..writeByte(6)
      ..write(obj.releaseDate);
  }
}
