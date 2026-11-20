import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_entity.freezed.dart';

/// Shared cast/crew aggregate reused by movies and TV series.
@freezed
abstract class CreditEntity with _$CreditEntity {
  const factory CreditEntity({
    required int id,
    @Default(<CastMember>[]) List<CastMember> cast,
    @Default(<CrewMember>[]) List<CrewMember> crew,
  }) = _CreditEntity;
}

@freezed
abstract class CastMember with _$CastMember {
  const factory CastMember({
    required int id,
    @Default('') String name,
    String? character,
    String? profilePath,
    String? posterPath,
    String? mediaType,
  }) = _CastMember;
}

@freezed
abstract class CrewMember with _$CrewMember {
  const factory CrewMember({
    required int id,
    @Default('') String name,
    String? profilePath,
    String? job,
    String? department,
  }) = _CrewMember;
}
