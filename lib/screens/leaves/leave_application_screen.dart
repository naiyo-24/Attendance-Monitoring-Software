import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';
import '../../providers/employee_provider.dart';
import '../../widgets/app_bar.dart';
import '../../cards/leaves/leave_search_filter_card.dart';
import '../../cards/leaves/leave_request_card.dart';
import '../../notifiers/leaves_notifier.dart';
import '../../providers/leaves_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/leaves.dart';
import '../../models/employee.dart';
import '../../theme/app_theme.dart';
import '../../widgets/side_nav_bar.dart';
import '../../widgets/loader.dart';
import 'dart:ui';

class LeaveApplicationScreen extends ConsumerStatefulWidget {
  const LeaveApplicationScreen({super.key});

  @override
  ConsumerState<LeaveApplicationScreen> createState() =>
      _LeaveApplicationScreenState();
}

class _LeaveApplicationScreenState
    extends ConsumerState<LeaveApplicationScreen> {
  late LeavesNotifier leavesNotifier;
  List<Leave> _allLeaves = [];
  String _search = '';
  DateTime? _filterDate;
  LeaveStatus? _filterStatus;
  bool _isLoading = false;
  String? _error;

  Widget _glassSection({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
          child: Padding(padding: const EdgeInsets.all(14), child: child),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    leavesNotifier = LeavesNotifier();
    _fetchAllLeavesForAdmin();
  }

  Future<void> _fetchAllLeavesForAdmin() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authNotifier = ref.read(authProvider);
      final employeeNotifier = ref.read(employeeNotifierProvider);
      final adminId = authNotifier.user?.adminId;
      if (adminId == null) {
        setState(() {
          _error = 'Admin not found. Please login again.';
          _isLoading = false;
        });
        return;
      }

      await employeeNotifier.fetchEmployees(adminId);
      final allLeaves = <Leave>[];
      for (final emp in employeeNotifier.employees) {
        await leavesNotifier.fetchLeavesByAdminAndEmployee(
          adminId: adminId,
          employee: emp,
        );
        allLeaves.addAll(leavesNotifier.leaves);
      }

      _allLeaves = allLeaves;
      leavesNotifier.setLeaves(allLeaves);
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _filterLeaves(
    String search,
    DateTime? date,
    Employee? employee,
    LeaveStatus? status,
  ) async {
    setState(() {
      _search = search;
      _filterDate = date;
      _filterStatus = status;
    });

    final authNotifier = ref.read(authProvider);
    final adminId = authNotifier.user?.adminId;
    if (adminId == null) return;

    if (employee == null) {
      leavesNotifier.setLeaves(_allLeaves);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await leavesNotifier.fetchLeavesByAdminAndEmployee(
        adminId: adminId,
        employee: employee,
      );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminUser = ref.watch(authProvider).user;
    // Use Riverpod for employee list in LeaveSearchFilterCard
    return LeavesProvider(
      notifier: leavesNotifier,
      child: Scaffold(
        appBar: const PremiumAppBar(
          title: 'Leave Applications',
          subtitle: 'Manage employee leave requests',
        ),
        drawer: adminUser == null ? null : SideNavBar(adminUser: adminUser),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _glassSection(
                    child: LeaveSearchFilterCard(onFilter: _filterLeaves),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: _isLoading
                        ? const AttendX24Loader(text: 'Loading leave requests…')
                        : _error != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: kCaptionTextStyle(context).copyWith(
                                  color: kerror,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          )
                        : AnimatedBuilder(
                            animation: leavesNotifier,
                            builder: (context, _) {
                              final visibleLeaves = leavesNotifier.leaves.where(
                                (leave) {
                                  final matchesSearch =
                                      _search.isEmpty ||
                                      leave.reason.toLowerCase().contains(
                                        _search.toLowerCase(),
                                      ) ||
                                      leave.employee.phone.contains(_search);
                                  final matchesDate =
                                      _filterDate == null ||
                                      (leave.date.year == _filterDate!.year &&
                                          leave.date.month ==
                                              _filterDate!.month &&
                                          leave.date.day == _filterDate!.day);
                                  final matchesStatus =
                                      _filterStatus == null ||
                                      leave.status == _filterStatus;
                                  return matchesSearch &&
                                      matchesDate &&
                                      matchesStatus;
                                },
                              ).toList();

                              if (visibleLeaves.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No leave requests found.',
                                    style: kDescriptionTextStyle(context)
                                        .copyWith(
                                          color: kBrown,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                itemCount: visibleLeaves.length,
                                itemBuilder: (context, idx) {
                                  final leave = visibleLeaves[idx];
                                  return LeaveRequestCard(leave: leave);
                                },
                              );
                            },
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
