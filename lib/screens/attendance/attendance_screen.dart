import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider;
import '../../utils/attendance_download_pdf.dart';
import '../../notifiers/attendance_notifier.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/loader.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/auth_provider.dart';
import '../../providers/employee_provider.dart';
import '../../cards/attendance/filter_card.dart';
import '../../cards/attendance/calendar_card.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  int? selectedEmployeeId;
  late final AttendanceNotifier _attendanceNotifier;

  @override
  void initState() {
    super.initState();
    _attendanceNotifier = AttendanceNotifier();
    Future.microtask(() {
      final auth = ref.read(authProvider);
      final adminId = auth.user?.adminId;
      if (adminId != null) {
        ref.read(employeeNotifierProvider).fetchEmployees(adminId);
      }
    });
  }

  @override
  void dispose() {
    _attendanceNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final adminId = auth.user?.adminId;
    final adminUser = auth.user;
    final employeeNotifier = ref.watch(employeeNotifierProvider);
    final employees = employeeNotifier.employees
        .map((e) => {'id': e.employeeId, 'name': e.name})
        .where((e) => e['id'] != null)
        .toList();

    return ChangeNotifierProvider<AttendanceNotifier>.value(
      value: _attendanceNotifier,
      child: Scaffold(
        drawer: adminUser == null ? null : SideNavBar(adminUser: adminUser),
        appBar: const PremiumAppBar(
          title: 'Attendance',
          subtitle: 'Employee attendance records',
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kWhite, kWhiteGrey],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kWhite.withAlpha(190),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: kBlack.withAlpha((0.06 * 255).toInt()),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kBlack.withAlpha((0.05 * 255).toInt()),
                            blurRadius: 28,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Attendance Sheet',
                                style: kHeaderTextStyle(context).copyWith(
                                  fontSize: Responsive.fontSize(context, 16),
                                  color: kBrown,
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.download, size: 20),
                              label: const Text('Download'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: kBrown,
                                side: BorderSide(
                                  color: kBrown.withAlpha((0.16 * 255).toInt()),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                textStyle: kCaptionTextStyle(
                                  context,
                                ).copyWith(fontWeight: FontWeight.w900),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Center(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 420,
                                        ),
                                        child: DownloadSheet(
                                          employees: employees,
                                          adminId: adminId ?? 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: employeeNotifier.isLoading && employees.isEmpty
                        ? const AttendX24Loader(text: 'Loading employees…')
                        : employeeNotifier.error != null
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Text(
                                    employeeNotifier.error!,
                                    textAlign: TextAlign.center,
                                    style: kCaptionTextStyle(context).copyWith(
                                      color: kerror,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  FilterCard(
                                    adminId: adminId ?? 0,
                                    employees: employees,
                                    onEmployeeSelected: (id) {
                                      setState(
                                        () => selectedEmployeeId = id,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 14),
                                  Expanded(
                                    child: selectedEmployeeId != null &&
                                            adminId != null
                                        ? CalendarCard(
                                            adminId: adminId,
                                            employeeId: selectedEmployeeId!,
                                          )
                                        : Center(
                                            child: Text(
                                              'Select an employee to view attendance.',
                                              textAlign: TextAlign.center,
                                              style: kCaptionTextStyle(
                                                context,
                                              ).copyWith(
                                                fontWeight: FontWeight.w800,
                                                color: kBrown.withAlpha(
                                                  (0.72 * 255).toInt(),
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
