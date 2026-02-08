import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/widgets/bookmark_button.dart';

void main() {
  testWidgets('BookmarkButton renders and responds to tap', (WidgetTester tester) async {
    bool pressed = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BookmarkButton(
            label: 'Test Button',
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      ),
    );

    // Verify label
    expect(find.text('Test Button'), findsOneWidget);

    // Tap button
    await tester.tap(find.byType(BookmarkButton));
    await tester.pump();

    // Verify callback was triggered
    expect(pressed, isTrue);
  });

  testWidgets('BookmarkButton renders in selected state', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BookmarkButton(
            label: 'Selected Button',
            isSelected: true,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Selected Button'), findsOneWidget);
  });
}