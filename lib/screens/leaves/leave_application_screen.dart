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


class LeaveApplicationScreen extends ConsumerStatefulWidget {
  const LeaveApplicationScreen({super.key});

  @override
  ConsumerState<LeaveApplicationScreen> createState() => _LeaveApplicationScreenState();
}
class _LeaveApplicationScreenState extends ConsumerState<LeaveApplicationScreen> {
	late LeavesNotifier leavesNotifier;
	List<Leave> filteredLeaves = [];

	@override
	void initState() {
		super.initState();
		leavesNotifier = LeavesNotifier();
		_fetchAllLeavesForAdmin();
	}

	Future<void> _fetchAllLeavesForAdmin() async {
		// Get current adminId from provider
		final container = ProviderContainer();
		final authNotifier = container.read(authProvider);
		final employeeNotifier = container.read(employeeNotifierProvider);
		if (authNotifier.user?.adminId != null) {
			await employeeNotifier.fetchEmployees(authNotifier.user!.adminId!);
			List<Leave> allLeaves = [];
			for (final emp in employeeNotifier.employees) {
				await leavesNotifier.fetchLeavesByAdminAndEmployee(adminId: authNotifier.user!.adminId!, employee: emp);
				allLeaves.addAll(leavesNotifier.leaves);
			}
			setState(() {
				leavesNotifier.setLeaves(allLeaves);
				filteredLeaves = allLeaves;
			});
		}
	}

	void _filterLeaves(String search, DateTime? date, Employee? employee) async {
		final authNotifier = ref.read(authProvider);
		if (employee != null) {
			// Fetch leaves for the selected employee from backend
			await leavesNotifier.fetchLeavesByAdminAndEmployee(
				adminId: authNotifier.user!.adminId!,
				employee: employee,
			);
			setState(() {
				filteredLeaves = leavesNotifier.leaves.where((leave) {
					final matchesSearch = search.isEmpty ||
						leave.reason.toLowerCase().contains(search.toLowerCase()) ||
						leave.employee.phone.contains(search);
					final matchesDate = date == null ||
						(leave.date.year == date.year && leave.date.month == date.month && leave.date.day == date.day);
					return matchesSearch && matchesDate;
				}).toList();
			});
		} else {
			// Optionally, fetch all leaves for all employees (or keep as is)
			setState(() {
				filteredLeaves = leavesNotifier.leaves.where((leave) {
					final matchesSearch = search.isEmpty ||
						leave.reason.toLowerCase().contains(search.toLowerCase()) ||
						leave.employee.phone.contains(search);
					final matchesDate = date == null ||
						(leave.date.year == date.year && leave.date.month == date.month && leave.date.day == date.day);
					return matchesSearch && matchesDate;
				}).toList();
			});
		}
	}

	Future<void> _approveLeave(int idx) async {
		final leave = filteredLeaves[idx];
		await leavesNotifier.updateLeaveStatus(
			leaveId: leave.leaveId!,
			status: LeaveStatus.approved,
		);
		setState(() {});
	}

	Future<void> _rejectLeave(int idx) async {
		final leave = filteredLeaves[idx];
		await leavesNotifier.updateLeaveStatus(
			leaveId: leave.leaveId!,
			status: LeaveStatus.rejected,
		);
		setState(() {});
	}


	@override
	Widget build(BuildContext context) {
		// Use Riverpod for employee list in LeaveSearchFilterCard
		return LeavesProvider(
			notifier: leavesNotifier,
			child: Scaffold(
				appBar: const PremiumAppBar(
					title: 'Leave Applications',
					subtitle: 'Manage employee leave requests',
				),
				drawer: const SideNavBar(),
				body: Padding(
					padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							LeaveSearchFilterCard(onFilter: _filterLeaves),
							const SizedBox(height: 16),
							Expanded(
								child: filteredLeaves.isEmpty
										? Center(child: Text('No leave requests found.', style: kDescriptionTextStyle(context)))
										: ListView.builder(
												itemCount: filteredLeaves.length,
												itemBuilder: (context, idx) {
													final leave = filteredLeaves[idx];
													return LeaveRequestCard(
														leave: leave,
														onApprove: leave.status == LeaveStatus.pending ? () => _approveLeave(idx) : null,
														onReject: leave.status == LeaveStatus.pending ? () => _rejectLeave(idx) : null,
													);
												},
											),
							),
						],
					),
				),
			),
		);
	}
}
