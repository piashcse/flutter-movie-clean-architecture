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

    MediaHubTab tab(
      String label,
      IconData icon,
      PageFetcher<Person> fetchPage,
    ) {
      return MediaHubTab(
        label: label,
        icon: icon,
        page: PagedMediaGrid<Person>(
          fetchPage: fetchPage,
          itemBuilder: (context, person) => MediaCard(
            imagePath: person.profilePath,
            title: person.name,
            isPerson: true,
            onTap: () => context.push(AppRoutes.artist(person.id)),
          ),
        ),
      );
    }

    return MediaHubPage(
      tabs: [
        tab(
          l10n.popular,
          Icons.favorite,
          (ref, page) => ref.read(popularPersonsProvider(page).future),
        ),
        tab(
          l10n.trending,
          Icons.trending_up,
          (ref, page) => ref.read(trendingPersonsProvider(page).future),
        ),
      ],
    );
  }
}
