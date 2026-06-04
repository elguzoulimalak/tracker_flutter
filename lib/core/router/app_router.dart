import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_flutter/features/auth/providers/auth_provider.dart';
import 'package:tracker_flutter/features/auth/screens/login_screen.dart';
import 'package:tracker_flutter/features/auth/screens/profile_screen.dart';
import 'package:tracker_flutter/features/auth/screens/signup_screen.dart';
import 'package:tracker_flutter/features/auth/screens/splash_screen.dart';
import 'package:tracker_flutter/features/dashboard/screens/dashboard_screen.dart';
import 'package:tracker_flutter/features/fuel/screens/add_fuel_entry_screen.dart';
import 'package:tracker_flutter/features/fuel/screens/fuel_history_screen.dart';
import 'package:tracker_flutter/features/maintenance/screens/add_maintenance_screen.dart';
import 'package:tracker_flutter/features/maintenance/screens/maintenance_categories_screen.dart';
import 'package:tracker_flutter/features/maintenance/screens/maintenance_history_screen.dart';
import 'package:tracker_flutter/features/vehicles/screens/add_edit_vehicle_screen.dart';
import 'package:tracker_flutter/features/vehicles/screens/vehicle_details_screen.dart';
import 'package:tracker_flutter/features/vehicles/screens/vehicles_list_screen.dart';

final appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/vehicles',
      builder: (context, state) => const VehiclesListScreen(),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) =>
              const AddEditVehicleScreen(),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) => VehicleDetailsScreen(
            vehicleId: state.pathParameters['id']!,
          ),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) => AddEditVehicleScreen(
                vehicleId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/fuel',
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) => AddFuelEntryScreen(
            vehicleId: state.uri.queryParameters['vehicleId'],
          ),
        ),
        GoRoute(
          path: 'history',
          builder: (context, state) => FuelHistoryScreen(
            vehicleId: state.uri.queryParameters['vehicleId'],
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/maintenance',
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) => AddMaintenanceScreen(
            vehicleId: state.uri.queryParameters['vehicleId'],
          ),
        ),
        GoRoute(
          path: 'history',
          builder: (context, state) => MaintenanceHistoryScreen(
            vehicleId: state.uri.queryParameters['vehicleId'],
          ),
        ),
        GoRoute(
          path: 'categories',
          builder: (context, state) =>
              const MaintenanceCategoriesScreen(),
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    // This will be handled by the app-level redirect
    return null;
  },
);

