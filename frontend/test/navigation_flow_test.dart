import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/input_form_page.dart';
import 'package:frontend/pages/results_page.dart';

class TestNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushed = [];
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    pushed.add(route);
  }
}

void main() {
  testWidgets('Full input flow navigates to /results', (WidgetTester tester) async {
    final observer = TestNavigatorObserver();

    await tester.pumpWidget(MaterialApp(
      home: const InputFormPage(),
      routes: {
        '/results': (context) => const ResultsPage(),
      },
      navigatorObservers: [observer],
    ));

    // Advance through the steps
    for (int i = 0; i < 4; i++) {
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
    }

    // Tap submit
    final submit = find.byKey(const Key('submit_button'));
    expect(submit, findsOneWidget);
    await tester.tap(submit);
    await tester.pumpAndSettle();

    // Verify a push to /results occurred
    final pushedNames = observer.pushed.map((r) => r.settings.name).toList();
    expect(pushedNames.contains('/results'), isTrue,
        reason: 'Expected navigator to push /results, pushed: $pushedNames');
  });
}
