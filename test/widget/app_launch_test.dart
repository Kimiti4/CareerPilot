import 'package:careerpilot_ai/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CareerPilotApp renders CP-00 bootstrap screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CareerPilotApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('CareerPilot AI'), findsOneWidget);
    expect(find.text('CP-00 Foundation Active'), findsOneWidget);
  });
}
