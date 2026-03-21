import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../theme/app_theme.dart';
import '../../cards/holiday/calendar_card.dart';
import '../../cards/holiday/holiday_detail_card.dart';
import '../../cards/holiday/create_edit_holiday_card.dart';
import '../../notifiers/holiday_notifier.dart';
import '../../providers/holiday_provider.dart';
import '../../models/holiday.dart';

class HolidayScreen extends StatefulWidget {
  const HolidayScreen({super.key});

  @override
  State<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _openCreateEditHoliday({int? index, Holiday? holiday}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CreateEditHolidayCard(
          date: holiday?.date ?? _selectedDay,
          occasion: holiday?.occasion,
          remarks: holiday?.remarks,
          onSave: (date, occasion, remarks) {
            final notifier = HolidayProvider.of(context);
            final newHoliday = Holiday(date: date, occasion: occasion, remarks: remarks);
            if (index != null) {
              notifier.updateHoliday(index, newHoliday);
            } else {
              notifier.addHoliday(newHoliday);
            }
            Navigator.pop(context);
            setState(() {
              _selectedDay = date;
            });
          },
        ),
      ),
    );
  }

  void _deleteHoliday(int index) {
    final notifier = HolidayProvider.of(context);
    notifier.deleteHoliday(index);
    setState(() {
      _selectedDay = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HolidayProvider(
      notifier: HolidayNotifier(),
      child: Builder(
        builder: (context) {
          final notifier = HolidayProvider.of(context);
          final holidays = notifier.holidays;
          final holidayDates = holidays.map((h) => h.date).toSet();
          final selectedHolidayIndex = holidays.indexWhere((h) => _selectedDay != null && _isSameDay(h.date, _selectedDay!));
          final selectedHoliday = selectedHolidayIndex != -1 ? holidays[selectedHolidayIndex] : null;

          return Scaffold(
            drawer: const SideNavBar(),
            appBar: const PremiumAppBar(
              title: 'Holiday List',
              subtitle: 'View & manage holidays',
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: kPremiumButtonStyle(context).copyWith(
                          backgroundColor: WidgetStateProperty.all(kGreen),
                          foregroundColor: WidgetStateProperty.all(kWhite),
                          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 18)),
                          textStyle: WidgetStateProperty.all(
                            kHeaderTextStyle(context).copyWith(fontSize: 18),
                          ),
                        ),
                        icon: const Icon(Icons.add, size: 26),
                        label: const Text('Create a New Holiday'),
                        onPressed: () => _openCreateEditHoliday(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CalendarCard(
                      focusedDay: _focusedDay,
                      holidayDates: holidayDates,
                      onDaySelected: (date) {
                        setState(() {
                          _selectedDay = date;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    if (selectedHoliday != null)
                      HolidayDetailCard(
                        occasion: selectedHoliday.occasion,
                        date: '${selectedHoliday.date.day}/${selectedHoliday.date.month}/${selectedHoliday.date.year}',
                        remarks: selectedHoliday.remarks,
                        onEdit: () => _openCreateEditHoliday(index: selectedHolidayIndex, holiday: selectedHoliday),
                        onDelete: () => _deleteHoliday(selectedHolidayIndex),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
