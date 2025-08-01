import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/popular_page.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/top_rated_page.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/up_coming_page.dart';
import 'now_playing_page.dart';


class MovieMainPage extends StatefulWidget {
  const MovieMainPage({super.key});

  @override
  State<MovieMainPage> createState() => _MovieMainPageState();
}

class _MovieMainPageState extends State<MovieMainPage> {
  int _selectedIndex = 0;

  final _pages = [
    NowPlayingPage(),
    PopularPage(),
    TopRatedPage(),
    UpComingPage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Now Playing'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Popular'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Top Rated'),
          BottomNavigationBarItem(icon: Icon(Icons.keyboard_arrow_down), label: 'Upcoming'),
        ],
      ),
    );
  }
}