
import 'package:flutter/material.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider;
import '../../cards/attendance/download_sheet.dart';
import '../../notifiers/attendance_notifier.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
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

	@override
	void initState() {
		super.initState();
		Future.microtask(() {
			final auth = ref.read(authProvider);
			final adminId = auth.user?.adminId;
			if (adminId != null) {
				ref.read(employeeNotifierProvider).fetchEmployees(adminId);
			}
		});
	}

	@override
	Widget build(BuildContext context) {
		final auth = ref.watch(authProvider);
		final adminId = auth.user?.adminId;
		final employeeNotifier = ref.watch(employeeNotifierProvider);
		final employees = employeeNotifier.employees
				.map((e) => {'id': e.employeeId, 'name': e.name})
				.where((e) => e['id'] != null)
				.toList();

		return ChangeNotifierProvider(
			create: (_) => AttendanceNotifier(),
			child: Builder(
				builder: (context) => Scaffold(
					backgroundColor: kWhiteGrey,
					drawer:  SideNavBar(adminUser: ref.watch(authProvider).user!),
					appBar: const PremiumAppBar(
						title: 'Attendance',
						subtitle: 'Employee attendance records',
					),
					body: Padding(
						padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
						child: Column(
							children: [
								Row(
									mainAxisAlignment: MainAxisAlignment.end,
									children: [
										OutlinedButton.icon(
											icon: const Icon(Icons.download, size: 20),
											label: const Text('Download Attendance Sheet'),
											style: OutlinedButton.styleFrom(
												foregroundColor: kBrown,
												side: BorderSide(color: kBrown.withOpacity(0.4)),
												shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
												padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
												textStyle: kDescriptionTextStyle(context).copyWith(fontWeight: FontWeight.bold),
											),
											onPressed: () {
												showDialog(
													context: context,
													builder: (context) => Center(
														child: Material(
															color: Colors.transparent,
															child: Container(
																constraints: const BoxConstraints(maxWidth: 420),
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
								const SizedBox(height: 10),
								if (employeeNotifier.isLoading)
									const Center(child: CircularProgressIndicator()),
								if (employeeNotifier.error != null)
									Text('Error: ${employeeNotifier.error}', style: const TextStyle(color: Colors.red)),
								if (!employeeNotifier.isLoading && employeeNotifier.error == null)
									FilterCard(
										adminId: adminId ?? 0,
										employees: employees,
										onEmployeeSelected: (id) {
											setState(() => selectedEmployeeId = id);
										},
									),
								const SizedBox(height: 16),
								if (selectedEmployeeId != null && adminId != null)
									Expanded(
										child: CalendarCard(
											adminId: adminId,
											employeeId: selectedEmployeeId!,
										),
									)
								else
									const Expanded(
										child: Center(child: Text('Select an employee to view attendance.')),
									),
							],
						),
					),
				),
			),
		);
	}
}
