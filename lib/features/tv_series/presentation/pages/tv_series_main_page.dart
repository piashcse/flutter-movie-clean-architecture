import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/pages/airing_today_page.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/pages/on_the_air_page.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/pages/popular_tv_series_page.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/pages/upcoming_tv_series_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TvSeriesMainPage extends ConsumerStatefulWidget {
  const TvSeriesMainPage({super.key});

  @override
  ConsumerState<TvSeriesMainPage> createState() => _TvSeriesMainPageState();
}

class _TvSeriesMainPageState extends ConsumerState<TvSeriesMainPage> {
  int _selectedIndex = 0;

  final _pages = [
    const AiringTodayPage(),
    const OnTheAirPage(),
    const PopularTvSeriesPage(),
    const UpcomingTvSeriesPage(),
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
            icon: Icon(Icons.today),
            label: 'Airing Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: 'On The Air',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Popular'),
          BottomNavigationBarItem(
            icon: Icon(Icons.upcoming),
            label: 'Upcoming',
          ),
        ],
      ),
    );
  }
}
