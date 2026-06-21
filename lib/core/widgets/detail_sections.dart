import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/entities/credit_entity.dart';
import 'package:flutter_movie_clean_architecture/core/localization/localization_helper.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/cached_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DescriptionSection extends ConsumerWidget {
  final String overview;
  final StateProvider<bool> expandedProvider;

  const DescriptionSection({
    super.key,
    required this.overview,
    required this.expandedProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(expandedProvider);
    final text = overview.isNotEmpty
        ? overview
        : context.translate('no_description_available');
    const maxLength = 95;

    final displayText = isExpanded || text.length <= maxLength
        ? text
        : text.substring(0, maxLength).trimRight();

    final toggleText = isExpanded
        ? ' ${context.translate('show_less')}'
        : ' ${context.translate('show_more')}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate('description'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () =>
                ref.read(expandedProvider.notifier).state = !isExpanded,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: displayText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  TextSpan(
                    text: toggleText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF00BCD4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendationsSection extends StatelessWidget {
  final AsyncValue<List<dynamic>> itemsAsync;
  final String titleKey;
  final String errorKey;
  final String Function(dynamic item) idGetter;
  final String? Function(dynamic item) posterPathGetter;
  final IconData errorIcon;
  final String routePrefix;

  const RecommendationsSection({
    super.key,
    required this.itemsAsync,
    required this.titleKey,
    required this.errorKey,
    required this.idGetter,
    required this.posterPathGetter,
    this.errorIcon = Icons.movie,
    required this.routePrefix,
  });

  @override
  Widget build(BuildContext context) {
    return itemsAsync.when(
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                context.translate(titleKey),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final posterPath = posterPathGetter(item);
                  return GestureDetector(
                    onTap: () => context.push('$routePrefix/${idGetter(item)}'),
                    child: CachedImage(
                      imageUrl: posterPath != null ? '$imageUrl$posterPath' : null,
                      width: 110,
                      height: 160,
                      fit: BoxFit.cover,
                      borderRadius: 12,
                      errorIcon: errorIcon,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          context.translate(errorKey),
          style: TextStyle(color: Colors.red[400]),
        ),
      ),
    );
  }
}

class CreditsSection extends StatelessWidget {
  final AsyncValue<CreditEntity> creditsAsync;

  const CreditsSection({super.key, required this.creditsAsync});

  @override
  Widget build(BuildContext context) {
    return creditsAsync.when(
      data: (credits) {
        final castList = credits.cast;
        if (castList.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Cast',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(
              height: 140,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: castList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 4),
                itemBuilder: (context, index) {
                  final cast = castList[index];
                  final castImageUrl = cast.profilePath != null
                      ? '$imageUrl${cast.profilePath}'
                      : null;

                  return InkWell(
                    onTap: () => context.push('/artistId/${cast.id}'),
                    borderRadius: BorderRadius.circular(50),
                    child: SizedBox(
                      width: 80,
                      child: Column(
                        children: [
                          CachedImage(
                            imageUrl: castImageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            isCircular: true,
                            errorIcon: Icons.person,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cast.name ?? 'Unknown',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          context.translate('failed_to_load_cast'),
          style: TextStyle(color: Colors.red[400]),
        ),
      ),
    );
  }
}
