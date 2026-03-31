import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../notifiers/attendance_notifier.dart';
import '../../models/attendance.dart';
import 'attendance_details_card.dart';

class CalendarCard extends StatelessWidget {
	final int adminId;
	final int employeeId;
	const CalendarCard({required this.adminId, required this.employeeId, super.key});

	@override
	Widget build(BuildContext context) {
		final attendanceList = context.watch<AttendanceNotifier>().attendanceList;
		final Map<DateTime, List<Attendance>> events = {};
		for (final att in attendanceList) {
			final date = DateTime.parse(att.date);
			events.putIfAbsent(date, () => []).add(att);
		}

		return Card(
			child: Padding(
				padding: const EdgeInsets.all(8.0),
				child: TableCalendar<Attendance>(
					firstDay: DateTime.utc(2020, 1, 1),
					lastDay: DateTime.utc(2100, 12, 31),
					focusedDay: DateTime.now(),
					eventLoader: (day) => events[DateTime(day.year, day.month, day.day)] ?? [],
					calendarBuilders: CalendarBuilders(
						markerBuilder: (context, date, events) {
							if (events.isNotEmpty) {
								return Align(
									alignment: Alignment.bottomCenter,
									child: Row(
										mainAxisAlignment: MainAxisAlignment.center,
										children: List.generate(events.length, (index) =>
											Container(
												margin: const EdgeInsets.symmetric(horizontal: 1),
												width: 6,
												height: 6,
												decoration: BoxDecoration(
													shape: BoxShape.circle,
													color: Colors.blue,
												),
											),
										),
									),
								);
							}
							return null;
						},
					),
					onDaySelected: (selectedDay, focusedDay) {
						final attList = events[DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] ?? [];
						if (attList.isNotEmpty) {
							showModalBottomSheet(
								context: context,
								builder: (_) => AttendanceDetailsCard(attendance: attList.first, adminId: adminId),
								isScrollControlled: true,
							);
						}
					},
				),
			),
		);
	}
}
