import 'package:careerpilot_ai/app/theme/app_tokens.dart';
import 'package:careerpilot_ai/shared/widgets/app_empty_state.dart';
import 'package:careerpilot_ai/shared/widgets/demo_capability_banner.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CareerPilot AI'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppTokens.spaceMd),
          children: [
            const DemoCapabilityBanner(
              title: 'CP-01 UI Foundation',
              description: 'Local-device workspace active. Select a workflow below to inspect screens and navigation.',
            ),
            const SizedBox(height: AppTokens.spaceLg),
            Text(
              'Core Workflows',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppTokens.spaceMd),
            _WorkflowActionCard(
              icon: Icons.description_outlined,
              title: 'CV Analysis',
              subtitle: 'Import a PDF CV, add a job description, and review grounded improvement suggestions.',
              buttonLabel: 'Open CV Analysis',
              onTap: () => context.push('/cv-import'),
            ),
            const SizedBox(height: AppTokens.spaceMd),
            _WorkflowActionCard(
              icon: Icons.mic_none_rounded,
              title: 'Interview Practice',
              subtitle: 'Practise a 3-question voice interview with device TTS, recording, and rubric review.',
              buttonLabel: 'Open Interview Practice',
              onTap: () => context.push('/interview-setup'),
            ),
            const SizedBox(height: AppTokens.spaceLg),
            Text(
              'Recent Activity',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppTokens.spaceMd),
            AppEmptyState(
              icon: Icons.history_outlined,
              title: 'No saved analyses or interviews yet',
              message: 'Local persistence will be enabled in CP-06. Completed CV analyses and interview sessions will appear here.',
              actionLabel: 'Inspect Settings',
              onAction: () => context.push('/settings'),
            ),
            const SizedBox(height: AppTokens.spaceMd),
            Text(
              'Demo 0.1 · Offline-First · No Cloud Uploads',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkflowActionCard extends StatelessWidget {
  const _WorkflowActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colors.primaryContainer,
                  foregroundColor: colors.onPrimaryContainer,
                  child: Icon(icon),
                ),
                const SizedBox(width: AppTokens.spaceMd),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTokens.spaceSm),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppTokens.spaceMd),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: onTap,
                child: Text(buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
