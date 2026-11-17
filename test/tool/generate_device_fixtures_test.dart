import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Rect;
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// One-off device-spike fixtures written under test_fixtures/ (gitignored).
/// Run only when regenerating; normal `flutter test` runs skip when present.
void main() {
  test('generate device spike fixture PDFs', () {
    final dir = Directory('test_fixtures');
    if (dir.existsSync()) {
      final existing = dir.listSync().where((f) => f.path.endsWith('.pdf'));
      if (existing.length >= 5) {
        stdout.writeln(
          'Device fixtures already present; leaving them untouched.',
        );
        return;
      }
    }
    dir.createSync(recursive: true);

    // 1. Multi-column CV: two text columns drawn on the same page.
    final multi = PdfDocument();
    final page = multi.pages.add();
    final heading = PdfStandardFont(
      PdfFontFamily.helvetica,
      14,
      style: PdfFontStyle.bold,
    );
    final body = PdfStandardFont(PdfFontFamily.helvetica, 10);
    page.graphics.drawString(
      'AMARA OKAFOR — SENIOR DATA ANALYST',
      heading,
      bounds: Rect.fromLTWH(24, 24, page.getClientSize().width - 48, 20),
    );
    final left = <String>[
      'LEFT COLUMN — EXPERIENCE',
      'Data Analyst | Nile Analytics (2021-Present)',
      '- Built SQL dashboards for 40+ retail clients.',
      '- Automated ETL with Python and Airflow.',
      '- Mentored 3 junior analysts on testing.',
    ];
    final right = <String>[
      'RIGHT COLUMN — SKILLS',
      'Python, SQL, Power BI, Airflow,',
      'Pandas, dbt, Statistical Testing,',
      'Stakeholder Communication,',
      'Agile Delivery, Mentoring.',
    ];
    double y = 60;
    for (final line in left) {
      page.graphics.drawString(
        line,
        body,
        bounds: Rect.fromLTWH(24, y, 240, 16),
      );
      y += 18;
    }
    y = 60;
    for (final line in right) {
      page.graphics.drawString(
        line,
        body,
        bounds: Rect.fromLTWH(300, y, 240, 16),
      );
      y += 18;
    }
    File('${dir.path}/multicolumn_cv.pdf')
        .writeAsBytesSync(Uint8List.fromList(multi.saveSync()));
    multi.dispose();

    // 2. Scanned / image-only PDF: draw rectangles only, zero text.
    final scanned = PdfDocument();
    final scannedPage = scanned.pages.add();
    scannedPage.graphics.drawRectangle(
      pen: PdfPen(PdfColor(0, 0, 0)),
      brush: PdfBrushes.lightGray,
      bounds: const Rect.fromLTWH(20, 20, 300, 400),
    );
    scannedPage.graphics.drawRectangle(
      pen: PdfPen(PdfColor(0, 0, 0)),
      brush: PdfBrushes.gray,
      bounds: const Rect.fromLTWH(60, 80, 200, 60),
    );
    File('${dir.path}/scanned_cv.pdf')
        .writeAsBytesSync(Uint8List.fromList(scanned.saveSync()));
    scanned.dispose();

    // 3. Password-protected / encrypted PDF.
    final encrypted = PdfDocument();
    encrypted.security.userPassword = 'cv-secret-123';
    encrypted.pages.add().graphics.drawString(
      'Confidential CV - unlocked copy required',
      PdfStandardFont(PdfFontFamily.helvetica, 12),
    );
    File('${dir.path}/encrypted_cv.pdf')
        .writeAsBytesSync(Uint8List.fromList(encrypted.saveSync()));
    encrypted.dispose();

    // 4. Oversized PDF above the 10 MB demo limit: minimal valid PDF whose
    //    body is one giant comment line, so it exceeds 10 MB on disk.
    final out = BytesBuilder();
    final offsets = <int>[0, 0, 0, 0];
    void obj(int n, String body) {
      offsets[n] = out.length;
      out.add(utf8.encode('$n 0 obj\n$body\nendobj\n'));
    }

    obj(1, '<< /Type /Catalog /Pages 2 0 R >>');
    obj(2, '<< /Type /Pages /Kids [3 0 R] /Count 1 >>');
    obj(3, '<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] >>');
    final xrefPos = out.length;
    out.add(utf8.encode('%${'a' * 11500000}\n'));
    final xref = StringBuffer('xref\n0 4\n0000000000 65535 f \n');
    for (var i = 1; i <= 3; i++) {
      xref.write('${offsets[i].toString().padLeft(10, '0')} 00000 n \n');
    }
    xref.write(
      'trailer\n<< /Size 4 /Root 1 0 R >>\nstartxref\n$xrefPos\n%%EOF\n',
    );
    out.add(utf8.encode(xref.toString()));
    File('${dir.path}/oversized_cv.pdf').writeAsBytesSync(out.takeBytes());

    // 5. Empty 0-byte file.
    File('${dir.path}/empty_cv.pdf').writeAsBytesSync(const <int>[]);

    for (final f in dir.listSync()) {
      stdout.writeln('${f.path} (${f.statSync().size} bytes)');
    }
    expect(File('${dir.path}/multicolumn_cv.pdf').lengthSync(), greaterThan(0));
    expect(File('${dir.path}/empty_cv.pdf').lengthSync(), 0);
  });
}
