import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/presentation/pages/celebrity_main_page.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/favorites_page.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/movie_main_page.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/pages/tv_series_main_page.dart';
import 'package:flutter_movie_clean_architecture/presentation/widgets/universal_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainTabPage extends ConsumerStatefulWidget {
  const MainTabPage({super.key});

  @override
  ConsumerState<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends ConsumerState<MainTabPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        title: const Text('Movie App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.movie), text: 'Movies'),
            Tab(icon: Icon(Icons.tv), text: 'TV Series'),
            Tab(icon: Icon(Icons.people), text: 'Celebrities'),
            Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: const [
              MovieMainPage(),
              TvSeriesMainPage(),
              CelebrityMainPage(),
              FavoritesPage(),
            ],
          ),
          if (_isSearching)
            UniversalSearchWidget(onClose: _closeSearch),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 48.0), // moves FAB upward
        child: FloatingActionButton(
          onPressed: _toggleSearch,
          child: const Icon(Icons.search),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      extendBody: true, // allows FAB to float over content
    );
  }
}