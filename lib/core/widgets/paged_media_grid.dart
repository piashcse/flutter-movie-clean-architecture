import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/core/utils/layout.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/app_status_views.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A reusable, responsive, infinitely scrolling media grid.
///
/// Owns pagination, refresh and error handling so feature pages stay tiny.
class PagedMediaGrid<T> extends ConsumerStatefulWidget {
  const PagedMediaGrid({
    super.key,
    required this.fetchPage,
    required this.itemBuilder,
    this.emptyMessage,
    this.pageSize = 20,
    this.padding = const EdgeInsets.all(12),
  });

  final Future<List<T>> Function(WidgetRef ref, int page) fetchPage;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String? emptyMessage;
  final int pageSize;
  final EdgeInsets padding;

  @override
  ConsumerState<PagedMediaGrid<T>> createState() => _PagedMediaGridState<T>();
}

class _PagedMediaGridState<T> extends ConsumerState<PagedMediaGrid<T>> {
  final ScrollController _scrollController = ScrollController();
  final List<T> _items = [];

  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _load(page: 1, replace: true);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasMore || _isLoading || _error != null) {
      return;
    }

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      _load(page: _page + 1, replace: false);
    }
  }

  Future<void> _load({required int page, required bool replace}) async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
      if (replace) {
        _error = null;
      }
    });

    try {
      final items = await widget.fetchPage(ref, page);
      if (!mounted) {
        return;
      }
      setState(() {
        if (replace) {
          _items.clear();
        }
        _items.addAll(items);
        _page = page;
        _hasMore = items.length >= widget.pageSize;
        _error = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _error = error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _refresh() => _load(page: 1, replace: true);

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      if (_isLoading) {
        return const AppLoadingView();
      }
      if (_error != null) {
        return AppErrorView(error: _error!, onRetry: _refresh);
      }
      return AppEmptyView(message: widget.emptyMessage ?? context.l10n.noData);
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = gridColumnsForWidth(constraints.maxWidth);

          return GridView.builder(
            controller: _scrollController,
            padding: widget.padding,
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _items.length + (_hasMore || _error != null ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _items.length) {
                return widget.itemBuilder(context, _items[index]);
              }
              if (_error != null) {
                return AppErrorView(
                  error: _error!,
                  compact: true,
                  onRetry: () => _load(page: _page + 1, replace: false),
                );
              }
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
