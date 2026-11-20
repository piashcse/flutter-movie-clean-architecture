import 'package:flutter_movie_clean_architecture/core/entities/credit_entity.dart';
import 'package:flutter_movie_clean_architecture/core/models/credit_model.dart';

/// Single mapping point for the credits payload shared by movies and TV.
extension CreditModelMapper on CreditModel {
  CreditEntity toEntity() => CreditEntity(
    id: id,
    cast: cast.map((member) => member.toEntity()).toList(growable: false),
    crew: crew.map((member) => member.toEntity()).toList(growable: false),
  );
}

extension CastModelMapper on CastModel {
  CastMember toEntity() => CastMember(
    id: id,
    name: name,
    character: character,
    profilePath: profilePath,
    posterPath: posterPath,
    mediaType: mediaType,
  );
}

extension CrewModelMapper on CrewModel {
  CrewMember toEntity() => CrewMember(
    id: id,
    name: name,
    profilePath: profilePath,
    job: job,
    department: department,
  );
}
