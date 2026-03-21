import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const SideNavBar(),
      appBar: const PremiumAppBar(
        title: 'Dashboard',
        subtitle: 'Overview',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            CountCards(count: dashboard.count),
            AttendanceGraphCard(graph: dashboard.attendanceGraph),
            const SizedBox(height: 16),
            const HomeFooter(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
