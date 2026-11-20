import 'package:flutter/material.dart';

class MediaHubTab {
  const MediaHubTab({
    required this.label,
    required this.icon,
    required this.page,
  });

  final String label;
  final IconData icon;
  final Widget page;
}

/// Shared scaffold for the movie / TV / celebrity hubs.
///
/// Tabs are built lazily on first visit and then kept alive, so opening the app
/// fetches one list instead of every section at once. Hidden tabs also have
/// tickers disabled to stop shimmer animations from consuming frames.
class MediaHubPage extends StatefulWidget {
  const MediaHubPage({super.key, required this.tabs});

  final List<MediaHubTab> tabs;

  @override
  State<MediaHubPage> createState() => _MediaHubPageState();
}

class _MediaHubPageState extends State<MediaHubPage>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;
  final Set<int> _visitedTabs = {0};

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(covariant MediaHubPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.tabs.length != oldWidget.tabs.length) {
      _visitedTabs.removeWhere((index) => index >= widget.tabs.length);
      if (_selectedIndex >= widget.tabs.length) {
        _selectedIndex = widget.tabs.isEmpty ? 0 : widget.tabs.length - 1;
      }
    }
  }

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
      _visitedTabs.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          for (var index = 0; index < widget.tabs.length; index++)
            TickerMode(
              enabled: index == _selectedIndex,
              child: _visitedTabs.contains(index)
                  ? widget.tabs[index].page
                  : const SizedBox.shrink(),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
        destinations: [
          for (final tab in widget.tabs)
            NavigationDestination(icon: Icon(tab.icon), label: tab.label),
        ],
      ),
    );
  }
}
