import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/core/entities/credit_entity.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/cached_image.dart';
import 'package:flutter_movie_clean_architecture/routing/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreditsSection extends StatelessWidget {
  const CreditsSection({super.key, required this.creditsAsync, this.onRetry});

  final AsyncValue<CreditEntity> creditsAsync;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return creditsAsync.when(
      data: (credits) {
        if (credits.cast.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                context.l10n.cast,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: credits.cast.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final member = credits.cast[index];

                  return Semantics(
                    button: true,
                    label: member.name,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => context.push(AppRoutes.artist(member.id)),
                      child: SizedBox(
                        width: 80,
                        child: Column(
                          children: [
                            CachedImage(
                              imageUrl: tmdbImage(
                                member.profilePath,
                                size: 'w185',
                              ),
                              width: 70,
                              height: 70,
                              isCircular: true,
                              errorIcon: Icons.person,
                              semanticLabel: member.name,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              member.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
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
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(context.l10n.failedToLoadCast)),
            if (onRetry != null)
              TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
          ],
        ),
      ),
    );
  }
}
