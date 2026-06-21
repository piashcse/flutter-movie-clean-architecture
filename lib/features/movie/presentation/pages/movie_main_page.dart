import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/localization/localization_helper.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/popular_page.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/top_rated_page.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/upcoming_movies_page.dart';
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.play_circle_fill),
            label: context.translate('now_playing'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: context.translate('popular'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.star),
            label: context.translate('top_rated'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.upcoming),
            label: context.translate('upcoming'),
          ),
        ],
      ),
    );
  }
}