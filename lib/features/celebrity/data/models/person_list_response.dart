import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/data/models/person_model.dart';

part 'person_list_response.freezed.dart';
part 'person_list_response.g.dart';

@freezed
class PersonListResponse with _$PersonListResponse {
  const factory PersonListResponse({
    @JsonKey(name: 'page') required int page,
    @JsonKey(name: 'results') required List<PersonModel> results,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'total_results') required int totalResults,
  }) = _PersonListResponse;

  factory PersonListResponse.fromJson(Map<String, dynamic> json) =>
      _$PersonListResponseFromJson(json);
}