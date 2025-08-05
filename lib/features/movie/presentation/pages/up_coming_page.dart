import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/widgets/movie_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpComingPage extends ConsumerStatefulWidget {
  const UpComingPage({super.key});

  @override
  ConsumerState<UpComingPage> createState() => _UpComingMoviePageState();
}

class _UpComingMoviePageState extends ConsumerState<UpComingPage> {
  final _scrollController = ScrollController();
  int _currentPage = 1;
  final List<Movie> _movies = [];
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPage(_currentPage);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          _hasMore) {
        _loadPage(++_currentPage);
      }
    });
  }

  Future<void> _loadPage(int page) async {
    setState(() {
      _isLoadingMore = true;
    });

    final result = await ref.read(upComingMoviesProvider(page).future);

    setState(() {
      if (result.isNotEmpty) {
        _movies.addAll(result);
      } else {
        _hasMore = false;
      }
      _isLoadingMore = false;
      _isInitialLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                return MovieCardWidget(movie: _movies[index]);
              },
            ),
          ),
          if (_hasMore && _isLoadingMore && !_isInitialLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 24.0, top: 8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}