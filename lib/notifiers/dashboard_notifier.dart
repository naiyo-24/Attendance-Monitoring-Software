import 'package:flutter/material.dart';
import '../models/count.dart';
import '../models/attendance_graph.dart';

class DashboardNotifier extends ChangeNotifier {
	Count _count = Count(employees: 0, holidays: 0, pendingLeaves: 0);
	AttendanceGraph _attendanceGraph = AttendanceGraph(
		months: [
			'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
			'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
		],
		present: List.filled(12, 0),
		absent: List.filled(12, 0),
	);

	Count get count => _count;
	AttendanceGraph get attendanceGraph => _attendanceGraph;

	void loadDashboardData() {
		// Simulate fetching data
		_count = Count(employees: 120, holidays: 15, pendingLeaves: 7);
		_attendanceGraph = AttendanceGraph(
			months: [
				'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
				'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
			],
			present: [22, 20, 23, 21, 20, 22, 23, 21, 22, 20, 21, 22],
			absent: [2, 3, 1, 2, 3, 2, 1, 3, 2, 3, 2, 1],
		);
		notifyListeners();
	}
}
