import 'package:careerpilot_ai/app/theme/app_tokens.dart';
import 'package:material_ui/material_ui.dart';

class DemoCapabilityBanner extends StatelessWidget {
  const DemoCapabilityBanner({
    super.key,
    required this.title,
    required this.description,
    this.isPlaceholder = false,
  });

  final String title;
  final String description;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTokens.spaceMd),
      decoration: BoxDecoration(
        color: isPlaceholder
            ? colors.secondaryContainer
            : colors.primaryContainer,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isPlaceholder
                ? Icons.construction_outlined
                : Icons.verified_user_outlined,
            color: isPlaceholder
                ? colors.onSecondaryContainer
                : colors.onPrimaryContainer,
          ),
          const SizedBox(width: AppTokens.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isPlaceholder
                        ? colors.onSecondaryContainer
                        : colors.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: AppTokens.spaceXs),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isPlaceholder
                        ? colors.onSecondaryContainer
                        : colors.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
