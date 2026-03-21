import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../cards/leaves/leave_search_filter_card.dart';
import '../../cards/leaves/leave_request_card.dart';
import '../../notifiers/leaves_notifier.dart';
import '../../providers/leaves_provider.dart';
import '../../notifiers/employee_notifier.dart';
import '../../providers/employee_provider.dart';
import '../../models/leaves.dart';
import '../../models/employee.dart';
import '../../theme/app_theme.dart';

class LeaveApplicationScreen extends StatefulWidget {
	const LeaveApplicationScreen({super.key});

	@override
	State<LeaveApplicationScreen> createState() => _LeaveApplicationScreenState();
}

class _LeaveApplicationScreenState extends State<LeaveApplicationScreen> {
	late LeavesNotifier leavesNotifier;
	late EmployeeNotifier employeeNotifier;
	List<Leave> filteredLeaves = [];

	@override
	void initState() {
		super.initState();
		leavesNotifier = LeavesNotifier();
		employeeNotifier = EmployeeNotifier();
		// Demo data
		if (leavesNotifier.leaves.isEmpty) {
			leavesNotifier.setLeaves(LeavesNotifier.demoLeaves());
		}
		filteredLeaves = leavesNotifier.leaves;
	}

	void _filterLeaves(String search, DateTime? date, Employee? employee) {
		setState(() {
			filteredLeaves = leavesNotifier.leaves.where((leave) {
				final matchesSearch = search.isEmpty ||
						leave.reason.toLowerCase().contains(search.toLowerCase()) ||
						leave.employee.phone.contains(search);
				final matchesDate = date == null ||
						(leave.date.year == date.year && leave.date.month == date.month && leave.date.day == date.day);
				final matchesEmployee = employee == null || leave.employee == employee;
				return matchesSearch && matchesDate && matchesEmployee;
			}).toList();
		});
	}

	void _updateLeaveStatus(int index, LeaveStatus status) {
		leavesNotifier.updateLeaveStatus(index, status);
		setState(() {});
	}

	@override
	Widget build(BuildContext context) {
		return EmployeeProvider(
			notifier: employeeNotifier,
			child: LeavesProvider(
				notifier: leavesNotifier,
				child: Scaffold(
					appBar: const PremiumAppBar(
						title: 'Leave Applications',
						subtitle: 'Manage employee leave requests',
					),
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
														final leaveIndex = leavesNotifier.leaves.indexOf(leave);
														return LeaveRequestCard(
															leave: leave,
															onApprove: leave.status == LeaveStatus.pending
																	? () => _updateLeaveStatus(leaveIndex, LeaveStatus.approved)
																	: null,
															onReject: leave.status == LeaveStatus.pending
																	? () => _updateLeaveStatus(leaveIndex, LeaveStatus.rejected)
																	: null,
														);
													},
												),
								),
							],
						),
					),
				),
			),
		);
	}
}
