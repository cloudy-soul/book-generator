import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/widgets/zodiac_selector.dart';

void main() {
  testWidgets('Zodiac selector shows selection when tapped', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: ZodiacConstellationSelector())));

    // Initially no selection text
    expect(find.byKey(const Key('zodiac_selection_text')), findsNothing);

    // Tap on 'Aries'
    await tester.tap(find.text('Aries'));
    await tester.pumpAndSettle();

    // Selection text should appear and contain Aries
    final selFinder = find.byKey(const Key('zodiac_selection_text'));
    expect(selFinder, findsOneWidget);
    expect(find.textContaining('Aries'), findsWidgets);
  });
}
