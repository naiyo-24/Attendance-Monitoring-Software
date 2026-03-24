import 'package:flutter/material.dart';

import '../models/leaves.dart';
import '../models/employee.dart';
import '../services/leave_request_services.dart';
import 'employee_notifier.dart';


class LeavesNotifier extends ChangeNotifier {
	final LeaveRequestService _service = LeaveRequestService();
	final List<Leave> _leaves = [];

	List<Leave> get leaves => List.unmodifiable(_leaves);

	Future<void> fetchLeavesByAdminAndEmployee({required int adminId, required Employee employee}) async {
		final leaves = await _service.fetchLeavesByAdminAndEmployee(adminId: adminId, employee: employee);
		_leaves.clear();
		_leaves.addAll(leaves);
		notifyListeners();
	}

	Future<void> updateLeaveStatus({required int leaveId, required LeaveStatus status, DateTime? date, String? reason}) async {
		await _service.updateLeaveStatus(leaveId: leaveId, status: status, date: date, reason: reason);
		final idx = _leaves.indexWhere((l) => l.leaveId == leaveId);
		if (idx != -1) {
			_leaves[idx].status = status;
			notifyListeners();
		}
	}

	void addLeave(Leave leave) {
		_leaves.add(leave);
		notifyListeners();
	}

	void setLeaves(List<Leave> leaves) {
		_leaves.clear();
		_leaves.addAll(leaves);
		notifyListeners();
	}

	/// Returns demo leaves using demo employees from EmployeeNotifier
	static List<Leave> demoLeaves() {
		final employees = EmployeeNotifier().employees;
		return [
			Leave(
				employee: employees[0],
				date: DateTime.now().subtract(const Duration(days: 1)),
				reason: 'Medical leave',
			),
			Leave(
				employee: employees[1],
				date: DateTime.now(),
				reason: 'Family function',
			),
			Leave(
				employee: employees[0],
				date: DateTime.now().subtract(const Duration(days: 3)),
				reason: 'Personal work',
				status: LeaveStatus.approved,
			),
			Leave(
				employee: employees[1],
				date: DateTime.now().subtract(const Duration(days: 5)),
				reason: 'Sick leave',
				status: LeaveStatus.rejected,
			),
			Leave(
				employee: employees[0],
				date: DateTime.now().subtract(const Duration(days: 7)),
				reason: 'Travel',
			),
		];
	}
}
