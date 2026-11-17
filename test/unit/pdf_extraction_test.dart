import 'dart:convert';
import 'dart:typed_data';

import 'package:careerpilot_ai/core/services/pdf_text_extractor.dart';
import 'package:careerpilot_ai/core/services/syncfusion_pdf_text_extractor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Rect;
import 'package:syncfusion_flutter_pdf/pdf.dart';

Uint8List _buildTextPdf(String content) {
  final doc = PdfDocument();
  final page = doc.pages.add();
  page.graphics.drawString(
    content,
    PdfStandardFont(PdfFontFamily.helvetica, 12),
    bounds: Rect.fromLTWH(20, 20, page.getClientSize().width - 40, 400),
  );
  final bytes = Uint8List.fromList(doc.saveSync());
  doc.dispose();
  return bytes;
}

Uint8List _buildNoTextPdf() {
  final doc = PdfDocument();
  final page = doc.pages.add();
  page.graphics.drawRectangle(
    pen: PdfPen(PdfColor(0, 0, 0)),
    bounds: const Rect.fromLTWH(10, 10, 100, 100),
  );
  final bytes = Uint8List.fromList(doc.saveSync());
  doc.dispose();
  return bytes;
}

Uint8List _buildEncryptedPdf() {
  final doc = PdfDocument();
  doc.security.userPassword = 'secret-password';
  doc.pages.add().graphics.drawString(
    'Confidential CV',
    PdfStandardFont(PdfFontFamily.helvetica, 12),
  );
  final bytes = Uint8List.fromList(doc.saveSync());
  doc.dispose();
  return bytes;
}

void main() {
  const extractor = SyncfusionPdfTextExtractor(maxFileBytes: 1024 * 1024);

  test('extracts text cleanly from valid PDF CV', () async {
    final bytes = _buildTextPdf(
      'Jane Doe - Python, SQL, REST API Integration, Data Analysis Experience across multiple systems.',
    );
    final result = await extractor.extractFromBytes(bytes);

    expect(result.pageCount, 1);
    expect(result.text, contains('Jane Doe'));
    expect(result.text, contains('Python'));
    expect(result.warning, isNull);
  });

  test('rejects empty 0-byte file', () async {
    await expectLater(
      () => extractor.extractFromBytes(Uint8List(0)),
      throwsA(
        isA<PdfExtractionException>().having(
          (e) => e.reason,
          'reason',
          PdfFailureReason.emptyFile,
        ),
      ),
    );
  });

  test('rejects oversized PDF above limit', () async {
    const smallLimit = SyncfusionPdfTextExtractor(maxFileBytes: 100);
    final bytes = _buildTextPdf('Valid CV text that exceeds 100 bytes total');

    await expectLater(
      () => smallLimit.extractFromBytes(bytes),
      throwsA(
        isA<PdfExtractionException>().having(
          (e) => e.reason,
          'reason',
          PdfFailureReason.fileTooLarge,
        ),
      ),
    );
  });

  test('rejects non-PDF file masquerading as PDF', () async {
    final fakeBytes = Uint8List.fromList(utf8.encode('Not actually a PDF'));
    await expectLater(
      () => extractor.extractFromBytes(fakeBytes),
      throwsA(
        isA<PdfExtractionException>().having(
          (e) => e.reason,
          'reason',
          PdfFailureReason.invalidFormat,
        ),
      ),
    );
  });

  test('rejects corrupted PDF bytes with PDF header', () async {
    final corrupted = Uint8List.fromList(
      utf8.encode('%PDF-1.7 corrupted body'),
    );
    await expectLater(
      () => extractor.extractFromBytes(corrupted),
      throwsA(
        isA<PdfExtractionException>().having(
          (e) => e.reason,
          'reason',
          PdfFailureReason.corrupted,
        ),
      ),
    );
  });

  test('rejects scanned or image-only PDF with no selectable text', () async {
    final bytes = _buildNoTextPdf();
    await expectLater(
      () => extractor.extractFromBytes(bytes),
      throwsA(
        isA<PdfExtractionException>().having(
          (e) => e.reason,
          'reason',
          PdfFailureReason.scannedOrNoText,
        ),
      ),
    );
  });

  test('rejects password-protected / encrypted PDF', () async {
    final bytes = _buildEncryptedPdf();
    await expectLater(
      () => extractor.extractFromBytes(bytes),
      throwsA(
        isA<PdfExtractionException>().having(
          (e) => e.reason,
          'reason',
          PdfFailureReason.encrypted,
        ),
      ),
    );
  });
}
