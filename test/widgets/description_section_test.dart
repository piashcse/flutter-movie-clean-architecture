import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/description_section.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void main() {
  testWidgets('collapses and expands long text', (tester) async {
    final longText = List.filled(60, 'A long synopsis sentence.').join(' ');

    await tester.pumpWidget(_app(DescriptionSection(text: longText)));

    expect(find.text('Show more'), findsOneWidget);
    expect(find.text('Show less'), findsNothing);

    await tester.tap(find.text('Show more'));
    await tester.pumpAndSettle();

    expect(find.text('Show less'), findsOneWidget);
  });

  testWidgets('shows the empty message when text is blank', (tester) async {
    await tester.pumpWidget(_app(const DescriptionSection(text: '')));

    expect(find.text('No description available.'), findsOneWidget);
    expect(find.text('Show more'), findsNothing);
  });
}
