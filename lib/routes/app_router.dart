import '../screens/current_location/current_location_map_screen.dart';

import '../screens/attendance/attendance_screen.dart';
import '../screens/help_center/help_center_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../screens/salary_slip/salary_slip_screen.dart';
import '../screens/my_notification/my_notification_screen.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/location_matrix/location_matrix_screen.dart';
import '../screens/location_matrix/map_picker_screen.dart';
import '../screens/employee/employee_screen.dart';
import '../screens/holiday/holiday_screen.dart';
import '../screens/leaves/leave_application_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: MapPickerScreen.routeName,
      builder: (context, state) {
        final lat = state.uri.queryParameters['lat'] != null
            ? double.tryParse(state.uri.queryParameters['lat']!)
            : null;
        final lng = state.uri.queryParameters['lng'] != null
            ? double.tryParse(state.uri.queryParameters['lng']!)
            : null;
        return MapPickerScreen(initialLat: lat, initialLng: lng);
      },
    ),
    GoRoute(
      path: '/attendance',
      builder: (context, state) => const AttendanceScreen(),
    ),
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/set-location-matrix',
      builder: (context, state) => const LocationMatrixScreen(),
    ),
    GoRoute(
      path: '/onboard-employees',
      builder: (context, state) => const EmployeeScreen(),
    ),
    GoRoute(
      path: '/location-tracking',
      builder: (context, state) => const CurrentLocationMapScreen(),
    ),
    GoRoute(
      path: '/holiday-list',
      builder: (context, state) => const HolidayScreen(),
    ),
    GoRoute(
      path: '/leave-applications',
      builder: (context, state) => const LeaveApplicationScreen(),
    ),
    GoRoute(
      path: '/salary-slip',
      builder: (context, state) => const SalarySlipScreen(),
    ),
    GoRoute(
      path: '/notification-management',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/my-notifications',
      builder: (context, state) => const MyNotificationScreen(),
    ),
    GoRoute(
      path: '/help-center',
      builder: (context, state) => const HelpCenterScreen(),
    ),
  ],
);
