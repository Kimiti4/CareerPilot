import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:careerpilot_ai/features/bootstrap/bootstrap_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'bootstrap',
        builder: (context, state) => const BootstrapScreen(),
      ),
    ],
  );
});
