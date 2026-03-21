import 'package:flutter/material.dart';
import '../models/leaves.dart';

import 'employee_notifier.dart';

class LeavesNotifier extends ChangeNotifier {
	final List<Leave> _leaves = [];

	List<Leave> get leaves => List.unmodifiable(_leaves);

	void addLeave(Leave leave) {
		_leaves.add(leave);
		notifyListeners();
	}

	void updateLeaveStatus(int index, LeaveStatus status) {
		if (index >= 0 && index < _leaves.length) {
			_leaves[index].status = status;
			notifyListeners();
		}
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
