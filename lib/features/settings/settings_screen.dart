import 'package:careerpilot_ai/app/theme/app_tokens.dart';
import 'package:careerpilot_ai/features/settings/settings_controller.dart';
import 'package:careerpilot_ai/shared/widgets/demo_capability_banner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmClearLocalData(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Local Data?'),
        content: const Text(
          'This removes locally saved CV text, analyses, and temporary interview audio from private app storage.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete Data'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ref.read(demoSettingsProvider.notifier).markLocalDataCleared();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Local demo state cleared (storage wipe wires in CP-06).',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(demoSettingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Privacy')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppTokens.spaceMd),
          children: [
            const DemoCapabilityBanner(
              title: 'Privacy Boundary (Demo 0.1)',
              description: 'CareerPilot runs offline on-device. No contacts, SMS, or location permissions are requested.',
            ),
            const SizedBox(height: AppTokens.spaceMd),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Temporary Audio Retention'),
                    subtitle: const Text(
                      'Keep mic recordings only during an active session; delete on completion (CP-04/CP-06).',
                    ),
                    value: settings.retainAudioTemporarily,
                    onChanged: (value) => ref
                        .read(demoSettingsProvider.notifier)
                        .setRetainAudioTemporarily(value),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.mic_none_rounded),
                    title: Text('Microphone Permission'),
                    subtitle: Text(
                      'Requested only when starting a voice interview (CP-04).',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTokens.spaceMd),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTokens.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Local Data Controls',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppTokens.spaceSm),
                    const Text(
                      'Delete all locally stored CVs, analyses, and interview attempts.',
                    ),
                    if (settings.lastClearTimestamp != null) ...[
                      const SizedBox(height: AppTokens.spaceSm),
                      Text(
                        'Last cleared (UTC): ${settings.lastClearTimestamp!.toIso8601String()}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: AppTokens.spaceMd),
                    OutlinedButton.icon(
                      onPressed: () => _confirmClearLocalData(context, ref),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete My Local Data'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
