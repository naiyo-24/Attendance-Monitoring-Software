import 'employee.dart';


enum LeaveStatus { pending, approved, rejected }

LeaveStatus leaveStatusFromString(String status) {
	switch (status.toLowerCase()) {
		case 'approved':
			return LeaveStatus.approved;
		case 'rejected':
			return LeaveStatus.rejected;
		default:
			return LeaveStatus.pending;
	}
}

String leaveStatusToString(LeaveStatus status) {
	switch (status) {
		case LeaveStatus.approved:
			return 'approved';
		case LeaveStatus.rejected:
			return 'rejected';
		case LeaveStatus.pending:
		return 'pending';
	}
}

class Leave {
	final int? leaveId;
	final Employee employee;
	final DateTime date;
	final String reason;
	LeaveStatus status;

	Leave({
		this.leaveId,
		required this.employee,
		required this.date,
		required this.reason,
		this.status = LeaveStatus.pending,
	});

	factory Leave.fromJson(Map<String, dynamic> json, Employee employee) {
		return Leave(
			leaveId: json['leave_id'] as int?,
			employee: employee,
			date: DateTime.parse(json['date']),
			reason: json['reason'] ?? '',
			status: json['status'] != null ? leaveStatusFromString(json['status']) : LeaveStatus.pending,
		);
	}

	Map<String, dynamic> toJson() => {
		if (leaveId != null) 'leave_id': leaveId,
		'employee_id': employee.employeeId,
		'date': date.toIso8601String(),
		'reason': reason,
		'status': leaveStatusToString(status),
	};
}
