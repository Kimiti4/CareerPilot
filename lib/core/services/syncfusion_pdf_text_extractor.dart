import 'dart:convert';
import 'dart:typed_data';

import 'package:careerpilot_ai/core/services/pdf_text_extractor.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;

class SyncfusionPdfTextExtractor implements PdfTextExtractor {
  const SyncfusionPdfTextExtractor({
    this.maxFileBytes = 10 * 1024 * 1024, // 10 MB safety limit
  });

  final int maxFileBytes;

  @override
  Future<PdfExtractionResult> extractFromBytes(Uint8List bytes) async {
    final stopwatch = Stopwatch()..start();

    if (bytes.isEmpty) {
      throw const PdfExtractionException(
        reason: PdfFailureReason.emptyFile,
        userMessage: 'The selected file is empty (0 bytes).',
      );
    }

    if (bytes.length > maxFileBytes) {
      final maxMb = (maxFileBytes / (1024 * 1024)).toStringAsFixed(0);
      throw PdfExtractionException(
        reason: PdfFailureReason.fileTooLarge,
        userMessage:
            'This PDF exceeds the $maxMb MB demo limit. Please select a smaller CV.',
      );
    }

    if (!_hasPdfHeader(bytes)) {
      throw const PdfExtractionException(
        reason: PdfFailureReason.invalidFormat,
        userMessage: 'This file does not appear to be a valid PDF document (%PDF- header missing).',
      );
    }

    sf.PdfDocument? document;
    try {
      document = sf.PdfDocument(inputBytes: bytes);
      final pageCount = document.pages.count;

      if (pageCount == 0) {
        throw const PdfExtractionException(
          reason: PdfFailureReason.corrupted,
          userMessage: 'This PDF contains no readable pages.',
        );
      }

      final extractor = sf.PdfTextExtractor(document);
      final rawText = extractor.extractText();
      final normalized = _normalizeText(rawText);

      if (normalized.isEmpty) {
        throw const PdfExtractionException(
          reason: PdfFailureReason.scannedOrNoText,
          userMessage: 'No selectable text was found. This looks like a scanned or image-only PDF, which requires OCR (not supported in Demo 0.1).',
        );
      }

      stopwatch.stop();

      String? warning;
      if (normalized.length < 80) {
        warning =
            'Very little text was extracted (${normalized.length} characters). Multi-column or image-heavy layouts may be incomplete—please inspect the preview.';
      }

      return PdfExtractionResult(
        text: normalized,
        pageCount: pageCount,
        byteLength: bytes.length,
        durationMs: stopwatch.elapsedMilliseconds,
        warning: warning,
      );
    } on PdfExtractionException {
      rethrow;
    } catch (e) {
      final lower = e.toString().toLowerCase();
      if (lower.contains('password') ||
          lower.contains('encrypt') ||
          lower.contains('security')) {
        throw const PdfExtractionException(
          reason: PdfFailureReason.encrypted,
          userMessage: 'This PDF is password-protected or encrypted. Please export an unlocked copy and try again.',
        );
      }
      throw const PdfExtractionException(
        reason: PdfFailureReason.corrupted,
        userMessage: 'Could not parse this PDF. The file may be corrupted or use an unsupported structure.',
      );
    } finally {
      document?.dispose();
    }
  }

  bool _hasPdfHeader(Uint8List bytes) {
    if (bytes.length < 5) return false;
    final prefix = ascii.decode(bytes.sublist(0, 5), allowInvalid: true);
    return prefix == '%PDF-';
  }

  String _normalizeText(String raw) {
    return raw
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .replaceAll(RegExp(r'[ \t]+\n'), '\n')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }
}
