import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../notifiers/attendance_notifier.dart';
import '../../models/attendance.dart';
import 'attendance_details_card.dart';
import '../../theme/app_theme.dart';

class CalendarCard extends StatefulWidget {
  final int adminId;
  final int employeeId;
  const CalendarCard({
    required this.adminId,
    required this.employeeId,
    super.key,
  });

  @override
  State<CalendarCard> createState() => _CalendarCardState();
}

class _CalendarCardState extends State<CalendarCard> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final attendanceList = context.watch<AttendanceNotifier>().attendanceList;
    final Map<DateTime, List<Attendance>> events = {};
    for (final att in attendanceList) {
      final date = DateTime.parse(att.date);
      events.putIfAbsent(date, () => []).add(att);
    }

    return Card(
      color: kWhite,
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: TableCalendar<Attendance>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              availableGestures: AvailableGestures.horizontalSwipe,
              rowHeight: 56,
              daysOfWeekHeight: 28,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: (day) =>
                  events[DateTime(day.year, day.month, day.day)] ?? [],
              calendarStyle: CalendarStyle(
                cellMargin: const EdgeInsets.all(6),
                cellPadding: const EdgeInsets.symmetric(vertical: 6),
                todayDecoration: BoxDecoration(
                  color: kBrown.withAlpha(15),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: kBrown,
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: kGreen,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: kDescriptionTextStyle(
                  context,
                ).copyWith(color: kPink),
                defaultTextStyle: kDescriptionTextStyle(context),
                outsideTextStyle: kDescriptionTextStyle(
                  context,
                ).copyWith(color: kPink.withAlpha(25)),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: kTaglineTextStyle(
                  context,
                ).copyWith(fontSize: 12, color: kBrown),
                weekendStyle: kTaglineTextStyle(
                  context,
                ).copyWith(fontSize: 12, color: kPink),
              ),
              headerStyle: HeaderStyle(
                headerPadding: const EdgeInsets.symmetric(vertical: 8),
                titleTextStyle: kHeaderTextStyle(
                  context,
                ).copyWith(fontSize: 18),
                formatButtonVisible: false,
                leftChevronIcon: Icon(Icons.chevron_left, color: kBrown),
                rightChevronIcon: Icon(Icons.chevron_right, color: kBrown),
                titleCentered: true,
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, markerEvents) {
                  if (markerEvents.isEmpty) return null;
                  final dotCount = markerEvents.length.clamp(1, 3);
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          dotCount,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: kGreen,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                final attList =
                    events[DateTime(
                      selectedDay.year,
                      selectedDay.month,
                      selectedDay.day,
                    )] ??
                    [];
                if (attList.isNotEmpty) {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => AttendanceDetailsCard(
                      attendance: attList.first,
                      adminId: widget.adminId,
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
        ),
      ),
    );
  }
}
