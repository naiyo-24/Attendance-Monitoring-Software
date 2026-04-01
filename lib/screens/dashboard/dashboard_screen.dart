import 'package:attendance_admin_panel/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../cards/dashboard/count_cards.dart';
import '../../cards/dashboard/attendance_graph_card.dart';
import '../../cards/dashboard/footer_card.dart';
import '../../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(dashboardProvider).loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(dashboardProvider);
    return Scaffold(
      backgroundColor: kWhiteGrey,
      drawer: SideNavBar(adminUser: ref.watch(authProvider).user!),
      appBar: const PremiumAppBar(
        title: 'Dashboard',
        subtitle: 'Overview',
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: SingleChildScrollView(
          key: ValueKey(dashboard.count.employees + dashboard.count.holidays + dashboard.count.pendingLeaves),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CountCards(count: dashboard.count),
                ),
                AttendanceGraphCard(graph: dashboard.attendanceGraph),
                const SizedBox(height: 24),
                const HomeFooter(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
