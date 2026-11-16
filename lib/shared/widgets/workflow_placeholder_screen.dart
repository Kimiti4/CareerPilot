import 'package:careerpilot_ai/app/theme/app_tokens.dart';
import 'package:careerpilot_ai/shared/widgets/demo_capability_banner.dart';
import 'package:material_ui/material_ui.dart';

class WorkflowPlaceholderScreen extends StatelessWidget {
  const WorkflowPlaceholderScreen({
    super.key,
    required this.title,
    required this.checkpointTag,
    required this.summary,
    required this.plannedControls,
    this.nextStepLabel,
    this.onNextStep,
  });

  final String title;
  final String checkpointTag;
  final String summary;
  final List<String> plannedControls;
  final String? nextStepLabel;
  final VoidCallback? onNextStep;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppTokens.spaceMd),
          children: [
            DemoCapabilityBanner(
              isPlaceholder: true,
              title: '$checkpointTag — UI Shell Ready',
              description:
                  'Navigation and layout verified in CP-01. Core processing for this step is scheduled in $checkpointTag.',
            ),
            const SizedBox(height: AppTokens.spaceMd),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTokens.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Planned Workflow Scope',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppTokens.spaceSm),
                    Text(summary, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: AppTokens.spaceMd),
                    ...plannedControls.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppTokens.spaceXs,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.chevron_right, size: 18),
                            const SizedBox(width: AppTokens.spaceXs),
                            Expanded(child: Text(item)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (nextStepLabel != null && onNextStep != null) ...[
              const SizedBox(height: AppTokens.spaceLg),
              FilledButton.icon(
                onPressed: onNextStep,
                icon: const Icon(Icons.arrow_forward),
                label: Text(nextStepLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
