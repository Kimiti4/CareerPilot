import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:careerpilot_ai/app/router.dart';
import 'package:careerpilot_ai/app/theme/app_theme.dart';

class CareerPilotApp extends ConsumerWidget {
  const CareerPilotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'CareerPilot AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
    );
  }
}
