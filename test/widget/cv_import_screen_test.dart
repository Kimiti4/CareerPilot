import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:careerpilot_ai/app/app.dart';
import 'package:careerpilot_ai/core/services/cv_file_picker_service.dart';
import 'package:careerpilot_ai/features/cv_import/cv_import_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class _FakePicker implements CvFilePickerService {
  _FakePicker(this.fileToReturn);
  final PickedCvFile? fileToReturn;

  @override
  Future<PickedCvFile?> pickPdf() async => fileToReturn;
}

Uint8List _sampleValidBytes() {
  final doc = PdfDocument();
  final page = doc.pages.add();
  page.graphics.drawString(
    'Alex Mwangi - Backend Engineer skilled in Python, PostgreSQL, Docker, and automated testing workflows.',
    PdfStandardFont(PdfFontFamily.helvetica, 12),
    bounds: Rect.fromLTWH(20, 20, page.getClientSize().width - 40, 400),
  );
  final bytes = Uint8List.fromList(doc.saveSync());
  doc.dispose();
  return bytes;
}

void main() {
  testWidgets(
    'CvImportScreen extracts valid picked PDF and unlocks next step',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final fakePicker = _FakePicker(
        PickedCvFile(name: 'alex_cv.pdf', bytes: _sampleValidBytes()),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cvFilePickerServiceProvider.overrideWithValue(fakePicker),
          ],
          child: const CareerPilotApp(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open CV Analysis'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select PDF CV'));
      await tester.pumpAndSettle();

      expect(find.text('alex_cv.pdf'), findsOneWidget);
      expect(find.textContaining('Alex Mwangi'), findsOneWidget);

      await tester.ensureVisible(find.text('Next: Add Job Description'));
      await tester.tap(find.text('Next: Add Job Description'));
      await tester.pumpAndSettle();
      expect(find.text('Job Description'), findsOneWidget);
    },
  );

  testWidgets('CvImportScreen shows honest error for invalid PDF file', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final fakePicker = _FakePicker(
      PickedCvFile(
        name: 'broken.pdf',
        bytes: Uint8List.fromList(utf8.encode('not a pdf')),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [cvFilePickerServiceProvider.overrideWithValue(fakePicker)],
        child: const CareerPilotApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open CV Analysis'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Select PDF CV'));
    await tester.pumpAndSettle();

    expect(find.text('PDF Could Not Be Imported'), findsOneWidget);
    expect(find.textContaining('%PDF- header missing'), findsOneWidget);
  });
}
