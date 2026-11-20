/// Type of entity returned by the universal search.
enum SearchResultType { movie, tv, celebrity }

/// UI-agnostic search hit. Replaces the previous `Map<String, dynamic>`
/// pseudo-model and keeps the search flow type-safe.
class SearchResult {
  const SearchResult({
    required this.id,
    required this.title,
    required this.type,
    this.imagePath,
  });

  final int id;
  final String title;
  final SearchResultType type;
  final String? imagePath;
}
