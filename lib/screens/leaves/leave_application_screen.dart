import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../cards/leaves/leave_search_filter_card.dart';
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
												  return null;
												
													// ...existing code...
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
