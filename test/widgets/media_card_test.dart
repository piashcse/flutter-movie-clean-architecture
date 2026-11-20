import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/media_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('reports taps and exposes a semantic label', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 120,
            height: 180,
            child: MediaCard(
              imagePath: null,
              title: 'Alien',
              onTap: () => taps++,
            ),
          ),
        ),
      ),
    );

    final labelled = find.byWidgetPredicate(
      (widget) => widget is Semantics && widget.properties.label == 'Alien',
    );
    expect(labelled, findsOneWidget);

    await tester.tap(find.byType(InkWell));
    expect(taps, 1);
  });
}
