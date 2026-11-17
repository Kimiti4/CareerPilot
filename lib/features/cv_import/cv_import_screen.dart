import 'package:careerpilot_ai/app/theme/app_tokens.dart';
import 'package:careerpilot_ai/features/cv_import/cv_import_controller.dart';
import 'package:careerpilot_ai/features/cv_import/cv_import_state.dart';
import 'package:careerpilot_ai/shared/widgets/app_empty_state.dart';
import 'package:careerpilot_ai/shared/widgets/app_error_state.dart';
import 'package:careerpilot_ai/shared/widgets/demo_capability_banner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class CvImportScreen extends ConsumerWidget {
  const CvImportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final importState = ref.watch(cvImportProvider);
    final controller = ref.read(cvImportProvider.notifier);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CV Import'),
        actions: [
          if (importState.document != null)
            IconButton(
              tooltip: 'Clear CV',
              onPressed: importState.isLoading ? null : controller.clearCv,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppTokens.spaceMd),
          children: [
            const DemoCapabilityBanner(
              title: 'CP-02 Local PDF Extraction',
              description: 'Reads selectable PDF text directly on your device (max 10 MB). Scanned/image PDFs without OCR are rejected honestly.',
            ),
            const SizedBox(height: AppTokens.spaceMd),
            Wrap(
              spacing: AppTokens.spaceSm,
              runSpacing: AppTokens.spaceSm,
              children: [
                FilledButton.icon(
                  onPressed: importState.isLoading
                      ? null
                      : controller.pickAndExtractPdf,
                  icon: const Icon(Icons.upload_file_outlined),
                  label: const Text('Select PDF CV'),
                ),
                OutlinedButton.icon(
                  onPressed: importState.isLoading
                      ? null
                      : controller.loadSampleCv,
                  icon: const Icon(Icons.description_outlined),
                  label: const Text('Load Sample CV'),
                ),
              ],
            ),
            const SizedBox(height: AppTokens.spaceMd),
            if (importState.isLoading)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(AppTokens.spaceLg),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: AppTokens.spaceMd),
                      Text('Extracting text from PDF on device...'),
                    ],
                  ),
                ),
              )
            else if (importState.errorMessage != null)
              AppErrorState(
                title: 'PDF Could Not Be Imported',
                message: importState.errorMessage!,
                retryLabel: 'Select Another PDF',
                onRetry: controller.pickAndExtractPdf,
              )
            else if (importState.document != null)
              _ImportedCvPreview(
                document: importState.document!,
                theme: theme,
                colors: colors,
              )
            else
              const AppEmptyState(
                icon: Icons.picture_as_pdf_outlined,
                title: 'No CV Imported Yet',
                message: 'Choose a text-based PDF from your phone storage or load the built-in sample CV to inspect extracted text.',
              ),
            const SizedBox(height: AppTokens.spaceLg),
            FilledButton.icon(
              onPressed: importState.hasValidCv
                  ? () => context.push('/job-description')
                  : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next: Add Job Description'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImportedCvPreview extends StatelessWidget {
  const _ImportedCvPreview({
    required this.document,
    required this.theme,
    required this.colors,
  });

  final ImportedCvDocument document;
  final ThemeData theme;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    final ext = document.extraction;
    final kb = (ext.byteLength / 1024).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTokens.spaceMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: colors.primary),
                    const SizedBox(width: AppTokens.spaceSm),
                    Expanded(
                      child: Text(
                        document.fileName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTokens.spaceSm),
                Text(
                  '${ext.pageCount} page(s) · $kb KB · Extracted in ${ext.durationMs} ms · ${ext.text.length} chars',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                if (ext.warning != null) ...[
                  const SizedBox(height: AppTokens.spaceSm),
                  Container(
                    padding: const EdgeInsets.all(AppTokens.spaceSm),
                    decoration: BoxDecoration(
                      color: colors.secondaryContainer,
                      borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                    ),
                    child: Text(
                      ext.warning!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppTokens.spaceMd),
        Text(
          'Extracted Text Preview (Read-Only)',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppTokens.spaceSm),
        Card(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 280),
            padding: const EdgeInsets.all(AppTokens.spaceMd),
            child: SingleChildScrollView(
              child: SelectableText(ext.text, style: theme.textTheme.bodySmall),
            ),
          ),
        ),
      ],
    );
  }
}
