import 'package:flutter_movie_clean_architecture/core/entities/search_result.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/presentation/providers/celebrity_provider.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/providers/tv_series_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SearchCategory { movies, tvSeries, celebrities }

final searchCategoryProvider =
    NotifierProvider<SearchCategoryNotifier, SearchCategory>(
      SearchCategoryNotifier.new,
    );

class SearchCategoryNotifier extends Notifier<SearchCategory> {
  @override
  SearchCategory build() => SearchCategory.movies;

  void select(SearchCategory category) => state = category;
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query;

  void clear() => state = '';
}

/// Debouncing is owned by the search field; this provider only reacts to the
/// committed query. Results are auto-disposed when the overlay closes.
final searchResultsProvider = FutureProvider.autoDispose<List<SearchResult>>((
  ref,
) async {
  final query = ref.watch(searchQueryProvider).trim();
  if (query.isEmpty) {
    return const <SearchResult>[];
  }

  switch (ref.watch(searchCategoryProvider)) {
    case SearchCategory.movies:
      final movies = await ref.watch(movieSearchProvider(query).future);
      return [
        for (final movie in movies)
          SearchResult(
            id: movie.id,
            title: movie.title,
            type: SearchResultType.movie,
            imagePath: movie.posterPath,
          ),
      ];
    case SearchCategory.tvSeries:
      final series = await ref.watch(tvSeriesSearchProvider(query).future);
      return [
        for (final item in series)
          SearchResult(
            id: item.id,
            title: item.name,
            type: SearchResultType.tv,
            imagePath: item.posterPath,
          ),
      ];
    case SearchCategory.celebrities:
      final people = await ref.watch(searchPersonsProvider(query).future);
      return [
        for (final person in people)
          SearchResult(
            id: person.id,
            title: person.name,
            type: SearchResultType.celebrity,
            imagePath: person.profilePath,
          ),
      ];
  }
});
