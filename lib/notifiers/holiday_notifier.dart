
import 'package:flutter/material.dart';
import '../models/holiday.dart';
import '../services/holiday_services.dart';

class HolidayNotifier extends ChangeNotifier {
  final HolidayService _holidayService;
  final int adminId;
  List<Holiday> _holidays = [];
  bool _isLoading = false;
  String? _error;

  HolidayNotifier({required this.adminId, HolidayService? holidayService})
      : _holidayService = holidayService ?? HolidayService();

  List<Holiday> get holidays => List.unmodifiable(_holidays);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchHolidays() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final holidays = await _holidayService.getHolidaysByAdmin(adminId: adminId);
      _holidays = holidays;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addHoliday(Holiday holiday) async {
    try {
      final created = await _holidayService.createHoliday(adminId: adminId, holiday: holiday);
      _holidays.add(created);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateHoliday(int index, Holiday holiday) async {
    if (index >= 0 && index < _holidays.length) {
      try {
        final updated = await _holidayService.updateHoliday(
          holidayId: _holidays[index].holidayId!,
          adminId: adminId,
          holiday: holiday,
        );
        _holidays[index] = updated;
        notifyListeners();
      } catch (e) {
        _error = e.toString();
        notifyListeners();
      }
    }
  }

  Future<void> deleteHoliday(int index) async {
    if (index >= 0 && index < _holidays.length) {
      try {
        await _holidayService.deleteHoliday(
          holidayId: _holidays[index].holidayId!,
          adminId: adminId,
        );
        _holidays.removeAt(index);
        notifyListeners();
      } catch (e) {
        _error = e.toString();
        notifyListeners();
      }
    }
  }
}
