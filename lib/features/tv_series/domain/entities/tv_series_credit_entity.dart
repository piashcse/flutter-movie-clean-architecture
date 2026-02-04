class TvSeriesCreditEntity {
  final int id;
  final List<Cast> cast;
  final List<Crew> crew;

  TvSeriesCreditEntity({
    required this.id,
    required this.cast,
    required this.crew,
  });
}

class Cast {
  final int id;
  final String? character;
  final String? name;
  final String? profilePath;
  final int? castId;
  final int? order;

  Cast({
    required this.id,
    this.character,
    this.name,
    this.profilePath,
    this.castId,
    this.order,
  });
}

class Crew {
  final int id;
  final String? name;
  final String? profilePath;
  final String? job;
  final String? department;

  Crew({
    required this.id,
    this.name,
    this.profilePath,
    this.job,
    this.department,
  });
}