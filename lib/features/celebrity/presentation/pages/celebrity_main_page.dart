import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/media_card.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/media_hub_page.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/paged_media_grid.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/entities/person.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/presentation/providers/celebrity_provider.dart';
import 'package:flutter_movie_clean_architecture/routing/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CelebrityMainPage extends ConsumerWidget {
  const CelebrityMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return MediaHubPage(
      tabs: [
        MediaHubTab(
          label: l10n.popular,
          icon: Icons.favorite,
          page: _PersonGrid(
            fetchPage: (ref, page) =>
                ref.read(popularPersonsProvider(page).future),
          ),
        ),
        MediaHubTab(
          label: l10n.trending,
          icon: Icons.trending_up,
          page: _PersonGrid(
            fetchPage: (ref, page) =>
                ref.read(trendingPersonsProvider(page).future),
          ),
        ),
      ],
    );
  }
}

class _PersonGrid extends StatelessWidget {
  const _PersonGrid({required this.fetchPage});

  final Future<List<Person>> Function(WidgetRef ref, int page) fetchPage;

  @override
  Widget build(BuildContext context) {
    return PagedMediaGrid<Person>(
      fetchPage: fetchPage,
      itemBuilder: (context, person) => MediaCard(
        imagePath: person.profilePath,
        title: person.name,
        isPerson: true,
        onTap: () => context.push(AppRoutes.artist(person.id)),
      ),
    );
  }
}
