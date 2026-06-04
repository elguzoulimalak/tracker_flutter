import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_flutter/core/router/app_router.dart';
import 'package:tracker_flutter/core/theme/app_theme.dart';
import 'package:tracker_flutter/features/auth/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/splash',
    routes: appRouter.routes,
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final user = authState.valueOrNull;

      if (isLoading) {
        return '/splash';
      }

      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (user == null) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        return '/dashboard';
      }

      return null;
    },
  );
});

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Tracker Flutter',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
