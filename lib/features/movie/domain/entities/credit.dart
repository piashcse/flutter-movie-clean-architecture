class Credit {
  final int id;
  final List<Cast>? cast;
  final List<Crew>? crew;

  Credit({
    required this.id,
    required this.cast,
    required this.crew,
  });
}

class Cast {
  final int id;
  final String name;
  final String? profilePath;

  Cast({
    required this.id,
    required this.name,
    required this.profilePath,
  });
}

class Crew {
  final int id;
  final String name;
  final String? profilePath;

  Crew({
    required this.id,
    required this.name,
    required this.profilePath,
  });
}
