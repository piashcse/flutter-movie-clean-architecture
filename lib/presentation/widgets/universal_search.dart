import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/entities/search_result.dart';
import 'package:flutter_movie_clean_architecture/core/error/failure_messages.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/cached_image.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/inline_error.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/shimmer_placeholders.dart';
import 'package:flutter_movie_clean_architecture/presentation/providers/search_provider.dart';
import 'package:flutter_movie_clean_architecture/routing/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UniversalSearchWidget extends ConsumerStatefulWidget {
  const UniversalSearchWidget({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  ConsumerState<UniversalSearchWidget> createState() =>
      _UniversalSearchWidgetState();
}

class _UniversalSearchWidgetState extends ConsumerState<UniversalSearchWidget> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(searchQueryProvider.notifier).clear();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) {
        return;
      }
      ref.read(searchQueryProvider.notifier).update(value);
    });
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    ref.read(searchQueryProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final query = ref.watch(searchQueryProvider);
    final category = ref.watch(searchCategoryProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.scrim.withValues(alpha: 0.5),
      body: SafeArea(
        child: Column(
          children: [
            Material(
              color: theme.scaffoldBackgroundColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            autofocus: true,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: l10n.searchHint,
                              border: InputBorder.none,
                            ),
                            onChanged: _onChanged,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          tooltip: l10n.search,
                          onPressed: _controller.text.isEmpty
                              ? widget.onClose
                              : _clear,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        for (final (label, value) in [
                          (l10n.movies, SearchCategory.movies),
                          (l10n.tvSeries, SearchCategory.tvSeries),
                          (l10n.celebrities, SearchCategory.celebrities),
                        ])
                          _categoryChip(
                            label: label,
                            category: value,
                            selected: category == value,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (query.isNotEmpty) _buildResults(),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: widget.onClose,
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryChip({
    required String label,
    required SearchCategory category,
    required bool selected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) =>
          ref.read(searchCategoryProvider.notifier).select(category),
    );
  }

  Widget _buildResults() {
    final l10n = context.l10n;
    final resultsAsync = ref.watch(searchResultsProvider);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 420),
      child: resultsAsync.when(
        data: (results) {
          if (results.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.noResults),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 8),
            itemCount: results.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) => _SearchResultTile(
              result: results[index],
              onTap: () {
                widget.onClose();
                context.push(_routeFor(results[index]));
              },
            ),
          );
        },
        loading: SearchResultsSkeleton.new,
        error: (error, _) => InlineError(
          message: failureMessage(context, error),
          onRetry: () => ref.invalidate(searchResultsProvider),
        ),
      ),
    );
  }

  String _routeFor(SearchResult result) => switch (result.type) {
    SearchResultType.movie => AppRoutes.movie(result.id),
    SearchResultType.tv => AppRoutes.tv(result.id),
    SearchResultType.celebrity => AppRoutes.artist(result.id),
  };
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.result, required this.onTap});

  final SearchResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final typeLabel = switch (result.type) {
      SearchResultType.movie => l10n.typeMovie,
      SearchResultType.tv => l10n.typeTv,
      SearchResultType.celebrity => l10n.typeCelebrity,
    };

    return ListTile(
      onTap: onTap,
      leading: CachedImage(
        imageUrl: tmdbImage(result.imagePath, size: 'w185'),
        width: 48,
        height: 64,
        borderRadius: 6,
        errorIcon: result.type == SearchResultType.celebrity
            ? Icons.person
            : Icons.movie,
        semanticLabel: result.title,
      ),
      title: Text(result.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(typeLabel),
    );
  }
}
