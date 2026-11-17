import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Rect;
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  test('generate sample CV PDF asset', () {
    final file = File('assets/sample_data/sample_cv.pdf');
    if (file.existsSync() && file.lengthSync() > 0) {
      // One-off fixture generator: never rewrite the committed asset on a
      // normal `flutter test` run. Delete assets/sample_data/sample_cv.pdf
      // to regenerate it.
      stdout.writeln(
        'Sample CV asset already present (${file.path}, ${file.lengthSync()} bytes); leaving it untouched.',
      );
      expect(file.existsSync(), isTrue);
      return;
    }

    final document = PdfDocument();
    final page = document.pages.add();
    final fontHeading = PdfStandardFont(
      PdfFontFamily.helvetica,
      16,
      style: PdfFontStyle.bold,
    );
    final fontSub = PdfStandardFont(
      PdfFontFamily.helvetica,
      12,
      style: PdfFontStyle.bold,
    );
    final fontBody = PdfStandardFont(PdfFontFamily.helvetica, 10);

    const lines = [
      'JORDAN KAMAU — SOFTWARE DEVELOPER',
      'Remote / Global · jordan.kamau@example.com',
      '',
      'SUMMARY',
      'Software developer with 3 years of experience building mobile and backend',
      'applications using Python, SQL, REST APIs, and Flutter.',
      '',
      'SKILLS',
      'Languages: Python, Dart, SQL',
      'Backend & Tools: FastAPI, PostgreSQL, Git, Automated Testing, API Integration',
      '',
      'EXPERIENCE',
      'Junior Software Engineer | Meridian Digital (2023 - Present)',
      '- Built REST API integrations in Python connecting client apps to SQL databases.',
      '- Worked on a student automation project to schedule daily test runs.',
      '- Collaborated with product and QA engineers to resolve production defects.',
      '',
      'EDUCATION',
      'BSc. Computer Science (2022)',
    ];

    double y = 24;
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.isEmpty) {
        y += 10;
        continue;
      }
      final font = i == 0
          ? fontHeading
          : (line == line.toUpperCase() && line.length < 20)
          ? fontSub
          : fontBody;
      // Bounds must be tall enough for the font's ascent/descent, otherwise
      // Syncfusion skips the glyphs entirely (spike finding: the 16 pt
      // heading was silently dropped from the content stream).
      final boxHeight = i == 0 ? 26.0 : 18.0;
      page.graphics.drawString(
        line,
        font,
        bounds: Rect.fromLTWH(
          24,
          y,
          page.getClientSize().width - 48,
          boxHeight,
        ),
      );
      y += i == 0 ? 28 : 16;
    }

    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(document.saveSync());
    document.dispose();
    stdout.writeln('Generated ${file.path} (${file.lengthSync()} bytes)');

    expect(file.existsSync(), isTrue);
    expect(file.lengthSync(), greaterThan(0));
  });
}
