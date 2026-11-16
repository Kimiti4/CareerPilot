import 'package:careerpilot_ai/app/app.dart';
import 'package:careerpilot_ai/shared/widgets/app_empty_state.dart';
import 'package:careerpilot_ai/shared/widgets/app_error_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('AppEmptyState and AppErrorState render actions cleanly', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              AppEmptyState(
                icon: Icons.inbox_outlined,
                title: 'Nothing Here',
                message: 'Add an item to begin.',
                actionLabel: 'Retry Check',
                onAction: () => tapped = true,
              ),
              AppErrorState(
                title: 'Load Failed',
                message: 'Could not read document.',
                onRetry: () => tapped = true,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Nothing Here'), findsOneWidget);
    expect(find.text('Load Failed'), findsOneWidget);

    await tester.tap(find.text('Try Again'));
    expect(tapped, isTrue);
  });

  testWidgets('Settings Delete Data dialog updates state on confirmation', (
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

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Delete My Local Data'), 200);
    await tester.tap(find.text('Delete My Local Data'));
    await tester.pumpAndSettle();

    expect(find.text('Delete Local Data?'), findsOneWidget);

    await tester.tap(find.text('Delete Data'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Last cleared (UTC):'), findsOneWidget);
  });
}
