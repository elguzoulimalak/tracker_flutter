import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_flutter/features/auth/models/app_user.dart';
import 'package:tracker_flutter/features/auth/services/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

final currentUserProvider = Provider<AppUser?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUser;
});

final signUpProvider =
    FutureProvider.family<AppUser, Map<String, String>>((ref, params) async {
  final authService = ref.watch(authServiceProvider);
  return authService.signUp(
    email: params['email']!,
    password: params['password']!,
  );
});

final signInProvider =
    FutureProvider.family<AppUser, Map<String, String>>((ref, params) async {
  final authService = ref.watch(authServiceProvider);
  return authService.signIn(
    email: params['email']!,
    password: params['password']!,
  );
});

final signOutProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.signOut();
});
