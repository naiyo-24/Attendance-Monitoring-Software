
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../notifiers/attendance_notifier.dart';
import '../../theme/app_theme.dart';

class FilterCard extends StatefulWidget {
	final int adminId;
	final List<Map<String, dynamic>> employees; // [{id: 1, name: 'John'}, ...]
	final void Function(int employeeId)? onEmployeeSelected;
	const FilterCard({required this.adminId, required this.employees, this.onEmployeeSelected, super.key});

	@override
	State<FilterCard> createState() => _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
	int? selectedEmployeeId;

	@override
	Widget build(BuildContext context) {
		return Card(
			color: kWhite,
			elevation: 3,
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
			child: Padding(
				padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
				child: Row(
					children: [
						Text('Select Employee:', style: kCaptionTextStyle(context)),
						const SizedBox(width: 16),
						Expanded(
							child: Container(
								padding: const EdgeInsets.symmetric(horizontal: 12),
								decoration: BoxDecoration(
									color: kWhiteGrey,
									borderRadius: BorderRadius.circular(12),
									border: Border.all(color: kBrown.withAlpha(2)),
								),
								child: DropdownButtonHideUnderline(
									child: DropdownButton<int>(
										value: selectedEmployeeId,
										hint: Text('SelectEmployee', style: kDescriptionTextStyle(context)),
										isExpanded: true,
										items: widget.employees.map((e) {
											return DropdownMenuItem<int>(
												value: e['id'],
												child: Text(e['name'], style: kDescriptionTextStyle(context)),
											);
										}).toList(),
										onChanged: (val) {
											setState(() => selectedEmployeeId = val);
											if (val != null) {
												context.read<AttendanceNotifier>().fetchAttendance(widget.adminId, val);
												if (widget.onEmployeeSelected != null) {
													widget.onEmployeeSelected!(val);
												}
											}
										},
									),
								),
							),
						),
					],
				),
			),
		);
	}
}
