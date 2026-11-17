import 'package:careerpilot_ai/core/services/pdf_text_extractor.dart';

class ImportedCvDocument {
  const ImportedCvDocument({
    required this.fileName,
    required this.extraction,
    required this.isSampleFixture,
  });

  final String fileName;
  final PdfExtractionResult extraction;
  final bool isSampleFixture;
}

class CvImportState {
  const CvImportState({
    this.isLoading = false,
    this.document,
    this.errorMessage,
  });

  final bool isLoading;
  final ImportedCvDocument? document;
  final String? errorMessage;

  bool get hasValidCv => document != null && errorMessage == null;

  CvImportState copyWith({
    bool? isLoading,
    ImportedCvDocument? document,
    bool clearDocument = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CvImportState(
      isLoading: isLoading ?? this.isLoading,
      document: clearDocument ? null : (document ?? this.document),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
