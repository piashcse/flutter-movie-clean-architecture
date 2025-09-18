import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/popular_page.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/top_rated_page.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/up_coming_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'now_playing_page.dart';

class MovieMainPage extends ConsumerStatefulWidget {
  const MovieMainPage({super.key});

  @override
  ConsumerState<MovieMainPage> createState() => _MovieMainPageState();
}

class _MovieMainPageState extends ConsumerState<MovieMainPage> {
  int _selectedIndex = 0;

  final _pages = [
    const NowPlayingPage(),
    const PopularPage(),
    const TopRatedPage(),
    const UpComingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_fill),
            label: 'Now Playing',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Popular'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Top Rated'),
          BottomNavigationBarItem(
            icon: Icon(Icons.upcoming),
            label: 'Upcoming',
          ),
        ],
      ),
    );
  }
}
