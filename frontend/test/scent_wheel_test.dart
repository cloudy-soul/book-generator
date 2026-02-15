import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/widgets/scent_wheel.dart';

void main() {
  testWidgets('ScentWheelSelector renders and handles selection', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ScentWheelSelector(),
        ),
      ),
    );

    // Verify initial state
    // Find the wheel CustomPaint by key (unique test hook)
    final wheelFinder = find.byKey(const Key('scent_wheel_paint'));
    expect(wheelFinder, findsOneWidget);
    expect(find.byType(ChoiceChip), findsNWidgets(6));
    // The selection text should not be visible initially
    expect(find.textContaining('You selected:'), findsNothing);

    // Tap a chip (e.g., Citrus)
    await tester.tap(find.text('Citrus'));
    // We use pump() instead of pumpAndSettle() because the wheel has an infinite rotation animation
    await tester.pump();

    // Verify selection text appears
    expect(find.text('You selected: Citrus'), findsOneWidget);

    // Tap another chip (e.g., Woody)
    await tester.tap(find.text('Woody'));
    await tester.pump();

    // Verify selection updates
    expect(find.text('You selected: Woody'), findsOneWidget);
    
    // Tap Woody again to deselect
    await tester.tap(find.text('Woody'));
    await tester.pump();
    
    // Verify selection text disappears
    expect(find.textContaining('You selected:'), findsNothing);
  });
}