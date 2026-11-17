import 'dart:typed_data';

import 'package:careerpilot_ai/core/services/cv_file_picker_service.dart';
import 'package:careerpilot_ai/core/services/pdf_text_extractor.dart';
import 'package:careerpilot_ai/core/services/syncfusion_pdf_text_extractor.dart';
import 'package:careerpilot_ai/features/cv_import/cv_import_state.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pdfTextExtractorProvider = Provider<PdfTextExtractor>(
  (ref) => const SyncfusionPdfTextExtractor(),
);

final cvFilePickerServiceProvider = Provider<CvFilePickerService>(
  (ref) => const DeviceCvFilePickerService(),
);

class CvImportNotifier extends Notifier<CvImportState> {
  @override
  CvImportState build() => const CvImportState();

  Future<void> pickAndExtractPdf() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final picked = await ref.read(cvFilePickerServiceProvider).pickPdf();
      if (picked == null) {
        state = state.copyWith(isLoading: false);
        return;
      }
      await _processBytes(
        fileName: picked.name,
        bytes: picked.bytes,
        isSampleFixture: false,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        clearDocument: true,
        errorMessage: 'Unable to read the selected file from device storage.',
      );
    }
  }

  Future<void> loadSampleCv() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final byteData = await rootBundle.load(
        'assets/sample_data/sample_cv.pdf',
      );
      final bytes = byteData.buffer.asUint8List();
      await _processBytes(
        fileName: 'sample_cv.pdf',
        bytes: bytes,
        isSampleFixture: true,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        clearDocument: true,
        errorMessage: 'Could not load the bundled sample CV fixture.',
      );
    }
  }

  Future<void> _processBytes({
    required String fileName,
    required Uint8List bytes,
    required bool isSampleFixture,
  }) async {
    try {
      final result = await ref
          .read(pdfTextExtractorProvider)
          .extractFromBytes(bytes);
      state = CvImportState(
        isLoading: false,
        document: ImportedCvDocument(
          fileName: fileName,
          extraction: result,
          isSampleFixture: isSampleFixture,
        ),
      );
    } on PdfExtractionException catch (e) {
      state = CvImportState(isLoading: false, errorMessage: e.userMessage);
    } catch (_) {
      state = const CvImportState(
        isLoading: false,
        errorMessage: 'Unexpected error while extracting text from this PDF.',
      );
    }
  }

  void clearCv() {
    state = const CvImportState();
  }
}

final cvImportProvider = NotifierProvider<CvImportNotifier, CvImportState>(
  CvImportNotifier.new,
);
