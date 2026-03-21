import '../screens/notification/notification_screen.dart';
import '../screens/salary_slip/salary_slip_screen.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/location_matrix/location_matrix_screen.dart';
import '../screens/employee/employee_screen.dart';

import '../screens/holiday/holiday_screen.dart';
import '../screens/leaves/leave_application_screen.dart';

final GoRouter appRouter = GoRouter(
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
  ],
);
