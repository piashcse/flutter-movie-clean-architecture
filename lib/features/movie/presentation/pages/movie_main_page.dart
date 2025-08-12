import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/popular_page.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/top_rated_page.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/up_coming_page.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/widgets/movie_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'now_playing_page.dart';

class MovieMainPage extends ConsumerStatefulWidget {
  const MovieMainPage({super.key});

  @override
  ConsumerState<MovieMainPage> createState() => _MovieMainPageState();
}

class _MovieMainPageState extends ConsumerState<MovieMainPage> {
  int _selectedIndex = 0;
  bool _isSearching = false;

  final _pages = [
    const NowPlayingPage(),
    const PopularPage(),
    const TopRatedPage(),
    const UpComingPage(),
  ];

  final _pageLabels = [
    'Flutter Movie',
    'Popular',
    'Top Rated',
    'Upcoming',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isSearching = false;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }

  void _closeSearch() {
    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageLabels[_selectedIndex]),
      ),
      body: Stack(
        children: [
          // Main content
          _pages[_selectedIndex],
          // Search overlay
          if (_isSearching)
            MovieSearchWidget(onClose: _closeSearch),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleSearch,
        child: const Icon(Icons.search),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Now Playing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Popular',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Top Rated',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard_arrow_down),
            label: 'Upcoming',
          ),
        ],
      ),
    );
  }
}