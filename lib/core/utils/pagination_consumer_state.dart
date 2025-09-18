import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A generic pagination state class for handling paginated data with infinite scroll
abstract class PaginationConsumerState<T, W extends ConsumerStatefulWidget>
    extends ConsumerState<W> {
  late ScrollController scrollController;
  int currentPage = 1;
  final List<T> items = [];
  bool isLoadingMore = false;
  bool hasMore = true;
  bool isInitialLoading = true;

  // Customizable parameters
  int threshold = 200; // Scroll threshold to trigger next page load
  int initialPage = 1; // Initial page number
  Axis scrollDirection = Axis.vertical; // Scroll direction
  bool reverse = false; // Whether to reverse the scroll direction

  @override
  void initState() {
    super.initState();
    currentPage = initialPage;
    scrollController = ScrollController();
    loadPage(currentPage);

    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - threshold &&
        !isLoadingMore &&
        hasMore) {
      loadPage(++currentPage);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  /// Load a specific page of data
  Future<void> loadPage(int page) async {
    if (page == initialPage) {
      setState(() {
        isInitialLoading = true;
      });
    } else {
      setState(() {
        isLoadingMore = true;
      });
    }

    try {
      final result = await fetchData(page);

      setState(() {
        if (result.isNotEmpty) {
          if (page == initialPage) {
            items.clear(); // Clear items only when refreshing first page
          }
          items.addAll(result);
        } else {
          hasMore = false;
        }
        isLoadingMore = false;
        isInitialLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoadingMore = false;
        isInitialLoading = false;
        hasMore = false; // Stop trying to load more on error
      });
    }
  }

  /// Refresh the data from the first page
  Future<void> refresh() async {
    currentPage = initialPage;
    hasMore = true;
    await loadPage(currentPage);
  }

  /// Abstract method to fetch data - must be implemented by subclasses
  Future<List<T>> fetchData(int page);

  /// Build the content with customizable options
  Widget buildContent({
    required BuildContext context,
    required Widget Function(T item) itemBuilder,
    ScrollPhysics? physics,
    EdgeInsets? padding,
    int crossAxisCount = 2,
    double childAspectRatio = 2 / 3,
    double crossAxisSpacing = 8,
    double mainAxisSpacing = 8,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  }) {
    if (isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: scrollController,
            scrollDirection: scrollDirection,
            reverse: reverse,
            padding: padding ?? const EdgeInsets.all(8),
            physics: physics,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
            ),
            itemCount: items.length + (hasMore && isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == items.length && hasMore && isLoadingMore) {
                return const Center(child: CircularProgressIndicator());
              }
              return itemBuilder(items[index]);
            },
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
          ),
        ),
        if (hasMore && isLoadingMore && !isInitialLoading)
          const Padding(
            padding: EdgeInsets.only(bottom: 24.0, top: 8.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  /// Build a list view instead of grid view
  Widget buildListContent({
    required BuildContext context,
    required Widget Function(T item) itemBuilder,
    ScrollPhysics? physics,
    EdgeInsets? padding,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  }) {
    if (isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: scrollDirection,
            reverse: reverse,
            padding: padding ?? const EdgeInsets.all(8),
            physics: physics,
            itemCount: items.length + (hasMore && isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == items.length && hasMore && isLoadingMore) {
                return const Center(child: CircularProgressIndicator());
              }
              return itemBuilder(items[index]);
            },
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
          ),
        ),
        if (hasMore && isLoadingMore && !isInitialLoading)
          const Padding(
            padding: EdgeInsets.only(bottom: 24.0, top: 8.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
