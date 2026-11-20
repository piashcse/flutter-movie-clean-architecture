import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/media_detail_scaffold.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/shimmer_placeholders.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  testWidgets('poster grid loading uses a single shimmer skeleton', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: MediaGridSkeleton())),
    );

    expect(find.byType(MediaGridSkeleton), findsOneWidget);
    expect(find.byType(Shimmer), findsOneWidget);
    expect(find.byType(SkeletonBox), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('detail loading uses the shimmer skeleton', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaDetailScaffold<int>(
          detailAsync: const AsyncLoading<int>(),
          onRetry: () {},
          builder: (context, data) => Text('$data'),
        ),
      ),
    );

    expect(find.byType(DetailSkeleton), findsOneWidget);
    expect(find.byType(Shimmer), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.pump(const Duration(milliseconds: 300));
  });
}
