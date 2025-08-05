import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieSearchWidget extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const MovieSearchWidget({
    super.key,
    required this.onClose,
  });

  @override
  ConsumerState<MovieSearchWidget> createState() => _MovieSearchWidgetState();
}

class _MovieSearchWidgetState extends ConsumerState<MovieSearchWidget> {
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _searchResults = [];

  Future<void> _movieSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ref.read(movieSearchProvider(query).future);
      setState(() {
        _searchResults = result.map<Map<String, String>>((movie) {
          return {
            'id': movie.id.toString() ?? '',
            'title': movie.title ?? '',
            'image': '$IMAGE_URL${movie.posterPath ?? ''}',
          };
        }).toList();
      });
    } catch (e) {
      debugPrint('Search error: $e');
      setState(() {
        _searchResults = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      _movieSearch(query);
    } else {
      setState(() {
        _searchResults.clear();
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults.clear();
    });
  }

  Widget _buildSearchResults() {

    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 24.0), // You can adjust this value
          child: Text('No results found.'),
        ),
      );
    }

    // Limit to maximum 4 movies
    final limitedResults = _searchResults.take(4).toList();

    return Container(
      constraints: const BoxConstraints(
        maxHeight: 400, // Height for 4 movies (100 height per movie)
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: limitedResults.length,
        itemBuilder: (context, index) {
          final movie = limitedResults[index];
          return GestureDetector(
            onTap: () {
              final movieId = movie['id'];
              if (movieId != null && movieId.isNotEmpty) {
                context.push('/movie/$movieId');
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      movie['image']!,
                      width: 70,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 70),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      movie['title']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5), // Semi-transparent overlay
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  // AppBar-like header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: 'Search movies...',
                              border: InputBorder.none,
                            ),
                            onChanged: _performSearch,
                          ),
                        ),
                        _isLoading
                            ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                            : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: _searchController.text.isNotEmpty ? _clearSearch : widget.onClose,
                        ),
                      ],
                    ),
                  ),
                  // Search Results
                  if (_searchController.text.isNotEmpty)
                    _buildSearchResults(),
                ],
              ),
            ),
            // Expanded area to capture taps and close search
            Expanded(
              child: GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}