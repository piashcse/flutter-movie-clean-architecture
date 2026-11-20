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
      final items = await ref.watch(movieSearchProvider(query).future);
      return _map(
        items,
        SearchResultType.movie,
        (movie) => movie.id,
        (movie) => movie.title,
        (movie) => movie.posterPath,
      );
    case SearchCategory.tvSeries:
      final items = await ref.watch(tvSeriesSearchProvider(query).future);
      return _map(
        items,
        SearchResultType.tv,
        (series) => series.id,
        (series) => series.name,
        (series) => series.posterPath,
      );
    case SearchCategory.celebrities:
      final items = await ref.watch(searchPersonsProvider(query).future);
      return _map(
        items,
        SearchResultType.celebrity,
        (person) => person.id,
        (person) => person.name,
        (person) => person.profilePath,
      );
  }
});

List<SearchResult> _map<T>(
  List<T> items,
  SearchResultType type,
  int Function(T item) id,
  String Function(T item) title,
  String? Function(T item) image,
) {
  return [
    for (final item in items)
      SearchResult(
        id: id(item),
        title: title(item),
        type: type,
        imagePath: image(item),
      ),
  ];
}
