import 'package:hive/hive.dart';

part 'favorite_model.g.dart';

@HiveType(typeId: 0)
class Favorite extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late int itemId;

  @HiveField(2)
  late String title;

  @HiveField(3)
  late String posterPath;

  @HiveField(4)
  late String type; // 'movie', 'tv', or 'celebrity'

  @HiveField(5)
  String? overview;

  @HiveField(6)
  String? releaseDate;

  Favorite({
    required this.id,
    required this.itemId,
    required this.title,
    required this.posterPath,
    required this.type,
    this.overview,
    this.releaseDate,
  });
}