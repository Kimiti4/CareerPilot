import 'package:careerpilot_ai/app/theme/app_tokens.dart';
import 'package:careerpilot_ai/shared/widgets/demo_capability_banner.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppTokens.spaceLg),
          children: [
            const SizedBox(height: AppTokens.spaceMd),
            Icon(Icons.work_outline_rounded, size: 48, color: colors.primary),
            const SizedBox(height: AppTokens.spaceMd),
            Text(
              'CareerPilot AI',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppTokens.spaceSm),
            Text(
              'Prepare stronger applications and practise structured interviews—running directly on your Android device.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppTokens.spaceLg),
            const DemoCapabilityBanner(
              title: 'Local-Device Demo 0.1',
              description: 'No account required. No cloud uploads. Your CVs, transcripts, and interview attempts remain on this device.',
            ),
            const SizedBox(height: AppTokens.spaceLg),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppTokens.spaceMd),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.description_outlined),
                      title: Text('CV-to-Job Analysis'),
                      subtitle: Text(
                        'Explainable skill checks grounded in your CV',
                      ),
                    ),
                    Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.mic_none_rounded),
                      title: Text('3-Question Voice Interview'),
                      subtitle: Text(
                        'Spoken prompts, mic capture, and rubric scoring',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTokens.spaceXl),
            FilledButton(
              onPressed: () => context.go('/dashboard'),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Get Started'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
