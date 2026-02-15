import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/widgets/genre_bookshelf.dart';

void main() {
  testWidgets('Genre bookshelf toggles selection and shows summary', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: GenreBookshelfSelector()),
    ));

    // Initially no selection text or empty
    final selFinder = find.byKey(const Key('genre_selection_text'));
    expect(selFinder, findsOneWidget);
    expect(find.textContaining('Selected:'), findsOneWidget);

    // Tap the Fiction chip
    final chipFinder = find.byKey(const Key('genre_chip_Fiction'));
    expect(chipFinder, findsOneWidget);
    await tester.tap(chipFinder);
    await tester.pumpAndSettle();

    // Summary should include Fiction
    expect(find.textContaining('Fiction'), findsWidgets);
  });
}
