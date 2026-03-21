import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../theme/app_theme.dart';

class CalendarCard extends StatelessWidget {
  final DateTime focusedDay;
  final Set<DateTime> holidayDates;
  final void Function(DateTime date) onDaySelected;
  const CalendarCard({
    super.key,
    required this.focusedDay,
    required this.holidayDates,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: kWhiteGrey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: SizedBox(
          width: 700, // Fixed width to ensure constraints for TableCalendar header
          child: TableCalendar(
            firstDay: DateTime(focusedDay.year - 1, 1, 1),
            lastDay: DateTime(focusedDay.year + 2, 12, 31),
            focusedDay: focusedDay,
            calendarFormat: CalendarFormat.month,
            headerStyle: HeaderStyle(
              titleTextStyle: kHeaderTextStyle(context).copyWith(fontSize: 18),
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronIcon: const Icon(Icons.chevron_left, color: kBrown),
              rightChevronIcon: const Icon(Icons.chevron_right, color: kBrown),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: kTaglineTextStyle(context).copyWith(color: kBrown, fontSize: 16, fontWeight: FontWeight.w600),
              weekendStyle: kTaglineTextStyle(context).copyWith(color: kPink, fontSize: 16, fontWeight: FontWeight.w600),
              dowTextFormatter: (date, locale) =>
                  ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7],
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: kGreen.withAlpha((0.2 * 255).toInt()),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: kGreen,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: kPink,
                shape: BoxShape.circle,
              ),
              markersAlignment: Alignment.bottomCenter,
              markerSizeScale: 0.3,
              defaultTextStyle: kDescriptionTextStyle(context),
              weekendTextStyle: kDescriptionTextStyle(context).copyWith(color: kPink),
            ),
            selectedDayPredicate: (date) => holidayDates.any((d) => _isSameDay(d, date)),
            eventLoader: (date) => holidayDates.any((d) => _isSameDay(d, date)) ? [date] : [],
            onDaySelected: (selectedDay, focusedDay) => onDaySelected(selectedDay),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
