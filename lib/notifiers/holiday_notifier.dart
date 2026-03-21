import 'package:flutter/material.dart';
import '../models/holiday.dart';

class HolidayNotifier extends ChangeNotifier {
  final List<Holiday> _holidays = [
    Holiday(date: DateTime(DateTime.now().year, 1, 1), occasion: 'New Year', remarks: 'First day of the year'),
    Holiday(date: DateTime(DateTime.now().year, 8, 15), occasion: 'Independence Day', remarks: 'National holiday'),
    Holiday(date: DateTime(DateTime.now().year, 10, 2), occasion: 'Gandhi Jayanti', remarks: 'Birthday of Mahatma Gandhi'),
    Holiday(date: DateTime(DateTime.now().year, 12, 25), occasion: 'Christmas', remarks: 'Christmas Day'),
  ];

  List<Holiday> get holidays => List.unmodifiable(_holidays);

  void addHoliday(Holiday holiday) {
    _holidays.add(holiday);
    notifyListeners();
  }

  void updateHoliday(int index, Holiday holiday) {
    if (index >= 0 && index < _holidays.length) {
      _holidays[index] = holiday;
      notifyListeners();
    }
  }

  void deleteHoliday(int index) {
    if (index >= 0 && index < _holidays.length) {
      _holidays.removeAt(index);
      notifyListeners();
    }
  }
}
