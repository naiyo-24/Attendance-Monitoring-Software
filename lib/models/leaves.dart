import 'employee.dart';

enum LeaveStatus { pending, approved, rejected }

class Leave {
	final Employee employee;
	final DateTime date;
	final String reason;
	LeaveStatus status;

	Leave({
		required this.employee,
		required this.date,
		required this.reason,
		this.status = LeaveStatus.pending,
	});
}
