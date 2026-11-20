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

/// Shared scaffold for the movie / TV / celebrity hubs: a bottom navigation
/// bar over an [IndexedStack] so each section keeps its scroll position.
class MediaHubPage extends StatefulWidget {
  const MediaHubPage({super.key, required this.tabs});

  final List<MediaHubTab> tabs;

  @override
  State<MediaHubPage> createState() => _MediaHubPageState();
}

class _MediaHubPageState extends State<MediaHubPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [for (final tab in widget.tabs) tab.page],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: [
          for (final tab in widget.tabs)
            NavigationDestination(icon: Icon(tab.icon), label: tab.label),
        ],
      ),
    );
  }
}
