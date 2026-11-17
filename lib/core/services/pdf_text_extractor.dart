import 'dart:typed_data';

enum PdfFailureReason {
  emptyFile,
  fileTooLarge,
  invalidFormat,
  encrypted,
  scannedOrNoText,
  corrupted,
  unexpected,
}

class PdfExtractionException implements Exception {
  const PdfExtractionException({
    required this.reason,
    required this.userMessage,
  });

  final PdfFailureReason reason;
  final String userMessage;

  @override
  String toString() => 'PdfExtractionException($reason): $userMessage';
}

class PdfExtractionResult {
  const PdfExtractionResult({
    required this.text,
    required this.pageCount,
    required this.byteLength,
    required this.durationMs,
    this.warning,
  });

  final String text;
  final int pageCount;
  final int byteLength;
  final int durationMs;
  final String? warning;
}

abstract interface class PdfTextExtractor {
  Future<PdfExtractionResult> extractFromBytes(Uint8List bytes);
}
