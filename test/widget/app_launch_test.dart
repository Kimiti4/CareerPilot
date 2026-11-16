import 'dart:ui';

import 'package:careerpilot_ai/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App launches to Welcome screen and enters Dashboard', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ProviderScope(child: CareerPilotApp()));
    await tester.pumpAndSettle();

    expect(find.text('CareerPilot AI'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Core Workflows'), findsOneWidget);
    expect(find.text('CV Analysis'), findsOneWidget);
    expect(find.text('Interview Practice'), findsOneWidget);
  });
}
