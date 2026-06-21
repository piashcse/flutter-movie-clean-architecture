import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/localization/localization_helper.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/cached_image.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/presentation/providers/celebrity_provider.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/providers/tv_series_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UniversalSearchWidget extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const UniversalSearchWidget({
    super.key,
    required this.onClose,
  });

  @override
  ConsumerState<UniversalSearchWidget> createState() => _UniversalSearchWidgetState();
}

class _UniversalSearchWidgetState extends ConsumerState<UniversalSearchWidget> {
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  int _activeTab = 0;
  Timer? _debounce;

  Future<void> _movieSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ref.read(movieSearchProvider(query).future);
      setState(() {
        _searchResults = result.map<Map<String, dynamic>>((movie) {
          return {
            'id': movie.id.toString() ?? '',
            'title': movie.title ?? '',
            'image': '$imageUrl${movie.posterPath ?? ''}',
            'type': 'movie',
          };
        }).toList();
      });
    } catch (e) {
      debugPrint('Movie search error: $e');
      setState(() {
        _searchResults = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _tvSeriesSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ref.read(tvSeriesSearchProvider(query).future);
      setState(() {
        _searchResults = result.map<Map<String, dynamic>>((tvSeries) {
          return {
            'id': tvSeries.id.toString() ?? '',
            'title': tvSeries.name ?? '',
            'image': '$imageUrl${tvSeries.posterPath ?? ''}',
            'type': 'tv',
          };
        }).toList();
      });
    } catch (e) {
      debugPrint('TV series search error: $e');
      setState(() {
        _searchResults = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _celebritySearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ref.read(searchPersonsResultProvider(query).future);
      setState(() {
        _searchResults = result.map<Map<String, dynamic>>((person) {
          return {
            'id': person.id.toString() ?? '',
            'title': person.name ?? '',
            'image': '$imageUrl${person.profilePath ?? ''}',
            'type': 'celebrity',
          };
        }).toList();
      });
    } catch (e) {
      debugPrint('Celebrity search error: $e');
      setState(() {
        _searchResults = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) {
    if (_activeTab == 0) {
      _movieSearch(query);
    } else if (_activeTab == 1) {
      _tvSeriesSearch(query);
    } else {
      _celebritySearch(query);
    }
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    setState(() {
      _searchResults.clear();
    });
  }

  void _switchTab(int index) {
    setState(() {
      _activeTab = index;
      if (_searchController.text.isNotEmpty) {
        _onSearchChanged(_searchController.text);
      }
    });
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Text(context.translate('no_data')),
        ),
      );
    }

    final limitedResults = _searchResults.take(4).toList();

    return Container(
      constraints: const BoxConstraints(
        maxHeight: 400,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: limitedResults.length,
        itemBuilder: (context, index) {
          final item = limitedResults[index];
          return GestureDetector(
            onTap: () {
              final id = item['id'];
              if (id != null && id.toString().isNotEmpty) {
                if (item['type'] == 'movie') {
                  context.push('/movie/$id');
                } else if (item['type'] == 'tv') {
                  context.push('/tv/$id');
                } else if (item['type'] == 'celebrity') {
                  context.push('/artistId/$id');
                }
                widget.onClose();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  CachedImage(
                    imageUrl: item['image'],
                    width: 70,
                    height: 100,
                    fit: BoxFit.cover,
                    borderRadius: 8,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item['title']!,
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
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: context.translate('search'),
                              border: InputBorder.none,
                            ),
                            onChanged: _onSearchChanged,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        ChoiceChip(
                          label: Text(context.translate('movies')),
                          selected: _activeTab == 0,
                          onSelected: (selected) => _switchTab(0),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: Text(context.translate('tv_series')),
                          selected: _activeTab == 1,
                          onSelected: (selected) => _switchTab(1),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: Text(context.translate('celebrities')),
                          selected: _activeTab == 2,
                          onSelected: (selected) => _switchTab(2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_searchController.text.isNotEmpty)
                    _buildSearchResults(),
                ],
              ),
            ),
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
