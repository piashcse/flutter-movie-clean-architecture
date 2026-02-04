import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/localization/localization_helper.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/presentation/pages/celebrity_main_page.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/favorites_page.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/movie_main_page.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/pages/tv_series_main_page.dart';
import 'package:flutter_movie_clean_architecture/presentation/widgets/universal_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme_toggle_widget.dart';

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
        title: Text(context.translate('app_title')),
        actions: const [
          ThemeToggleWidget(),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.movie),
              text: context.translate('movies'),
            ),
            Tab(
              icon: const Icon(Icons.tv),
              text: context.translate('tv_series'),
            ),
            Tab(
              icon: const Icon(Icons.people),
              text: context.translate('celebrities'),
            ),
            Tab(
              icon: const Icon(Icons.favorite),
              text: context.translate('favorites'),
            ),
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
          tooltip: context.translate('search'),
          child: const Icon(Icons.search),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      extendBody: true, // allows FAB to float over content
    );
  }
}