import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/core/localization/language_toggle_widget.dart';
import 'package:flutter_movie_clean_architecture/core/theme/theme_toggle_widget.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/presentation/pages/celebrity_main_page.dart';
import 'package:flutter_movie_clean_architecture/features/favorites/favorites_page.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/pages/movie_main_page.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/pages/tv_series_main_page.dart';
import 'package:flutter_movie_clean_architecture/presentation/widgets/universal_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainTabPage extends ConsumerStatefulWidget {
  const MainTabPage({super.key});

  @override
  ConsumerState<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends ConsumerState<MainTabPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 4,
    vsync: this,
  );
  bool _isSearching = false;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleSearch() => setState(() => _isSearching = !_isSearching);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: const [LanguageToggleWidget(), ThemeToggleWidget()],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.movie), text: l10n.movies),
            Tab(icon: const Icon(Icons.tv), text: l10n.tvSeries),
            Tab(icon: const Icon(Icons.people), text: l10n.celebrities),
            Tab(icon: const Icon(Icons.favorite), text: l10n.favorites),
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
            UniversalSearchWidget(
              onClose: () => setState(() => _isSearching = false),
            ),
        ],
      ),
      floatingActionButton: Padding(
        // Keep the FAB clear of the nested NavigationBar in each tab.
        padding: const EdgeInsets.only(bottom: 72),
        child: FloatingActionButton(
          onPressed: _toggleSearch,
          tooltip: l10n.search,
          child: const Icon(Icons.search),
        ),
      ),
    );
  }
}
