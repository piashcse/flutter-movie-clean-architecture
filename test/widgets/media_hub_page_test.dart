import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/widgets/media_hub_page.dart';
import 'package:flutter_test/flutter_test.dart';

class _Probe extends StatefulWidget {
  const _Probe({required this.name, required this.built});

  final String name;
  final Set<String> built;

  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> {
  @override
  void initState() {
    super.initState();
    widget.built.add(widget.name);
  }

  @override
  Widget build(BuildContext context) => Text(widget.name);
}

void main() {
  testWidgets('builds tabs lazily and keeps visited tabs alive', (
    tester,
  ) async {
    final built = <String>{};

    await tester.pumpWidget(
      MaterialApp(
        home: MediaHubPage(
          tabs: [
            MediaHubTab(
              label: 'One',
              icon: Icons.movie,
              page: _Probe(name: 'one', built: built),
            ),
            MediaHubTab(
              label: 'Two',
              icon: Icons.tv,
              page: _Probe(name: 'two', built: built),
            ),
            MediaHubTab(
              label: 'Three',
              icon: Icons.people,
              page: _Probe(name: 'three', built: built),
            ),
          ],
        ),
      ),
    );

    expect(built, {'one'});

    await tester.tap(find.text('Two'));
    await tester.pumpAndSettle();
    expect(built, {'one', 'two'});

    await tester.tap(find.text('One'));
    await tester.pumpAndSettle();
    expect(built, {'one', 'two'}, reason: 'visited tabs must not rebuild');
    expect(built, isNot(contains('three')));
  });
}
