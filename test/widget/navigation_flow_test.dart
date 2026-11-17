import 'dart:ui';

import 'package:careerpilot_ai/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('All CV, Interview, and Settings routes are reachable', (
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

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // 1. Walk CV workflow
    await tester.tap(find.text('Open CV Analysis'));
    await tester.pumpAndSettle();
    expect(find.text('CV Import'), findsOneWidget);

    await tester.tap(find.text('Load Sample CV'));
    await tester.pumpAndSettle();
    expect(find.text('sample_cv.pdf'), findsOneWidget);

    await tester.ensureVisible(find.text('Next: Add Job Description'));
    await tester.tap(find.text('Next: Add Job Description'));
    await tester.pumpAndSettle();
    expect(find.text('Job Description'), findsOneWidget);

    await tester.tap(find.text('Next: Analyse Compatibility'));
    await tester.pumpAndSettle();
    expect(find.text('CV Analysis'), findsOneWidget);

    await tester.tap(find.text('Next: Review CV Suggestions'));
    await tester.pumpAndSettle();
    expect(find.text('CV Suggestions'), findsOneWidget);

    // Return to Dashboard
    for (var i = 0; i < 4; i++) {
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
    expect(find.text('Core Workflows'), findsOneWidget);

    // 2. Walk Interview workflow
    await tester.tap(find.text('Open Interview Practice'));
    await tester.pumpAndSettle();
    expect(find.text('Interview Setup'), findsOneWidget);

    await tester.tap(find.text('Next: Start Interview Session'));
    await tester.pumpAndSettle();
    expect(find.text('Interview Session'), findsOneWidget);

    await tester.tap(find.text('Next: View Interview Results'));
    await tester.pumpAndSettle();
    expect(find.text('Interview Results'), findsOneWidget);

    // Return to Dashboard
    for (var i = 0; i < 3; i++) {
      await tester.pageBack();
      await tester.pumpAndSettle();
    }

    // 3. Open Settings
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings & Privacy'), findsOneWidget);
  });
}
