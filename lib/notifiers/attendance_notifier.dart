import 'package:flutter/material.dart';
import '../models/attendance.dart';
import '../services/attendance_services.dart';

class AttendanceNotifier extends ChangeNotifier {
	final AttendanceService _service = AttendanceService();

	List<Attendance> _attendanceList = [];
	List<Attendance> get attendanceList => _attendanceList;

	bool _loading = false;
	bool get loading => _loading;

	String? _error;
	String? get error => _error;

	Future<void> fetchAttendance(int adminId, int employeeId) async {
		_loading = true;
		_error = null;
		notifyListeners();
		try {
			_attendanceList = await _service.fetchAttendanceByAdminAndEmployee(adminId, employeeId);
		} catch (e) {
			_error = e.toString();
		}
		_loading = false;
		notifyListeners();
	}

	Future<bool> updateAttendanceStatus({
		required int attendanceId,
		required int adminId,
		required AttendanceStatus status,
	}) async {
		try {
			final result = await _service.updateAttendanceStatus(
				attendanceId: attendanceId,
				adminId: adminId,
				status: status,
			);
			if (result) {
				final idx = _attendanceList.indexWhere((a) => a.attendanceId == attendanceId);
				if (idx != -1) {
					_attendanceList[idx] = Attendance(
						attendanceId: _attendanceList[idx].attendanceId,
						adminId: _attendanceList[idx].adminId,
						employeeId: _attendanceList[idx].employeeId,
						date: _attendanceList[idx].date,
						checkInTime: _attendanceList[idx].checkInTime,
						checkOutTime: _attendanceList[idx].checkOutTime,
						checkInPhoto: _attendanceList[idx].checkInPhoto,
						checkOutPhoto: _attendanceList[idx].checkOutPhoto,
						checkInLatitude: _attendanceList[idx].checkInLatitude,
						checkInLongitude: _attendanceList[idx].checkInLongitude,
						checkOutLatitude: _attendanceList[idx].checkOutLatitude,
						checkOutLongitude: _attendanceList[idx].checkOutLongitude,
						status: status,
					);
					notifyListeners();
				}
			}
			return result;
		} catch (e) {
			_error = e.toString();
			notifyListeners();
			return false;
		}
	}
}
