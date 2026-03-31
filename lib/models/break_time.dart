class BreakTime {
	final int breakId;
	final int attendanceId;
	final int employeeId;
	final int adminId;
	final String? breakInTime;
	final String? breakOutTime;
	final String? breakInPhoto;
	final String? breakOutPhoto;

	BreakTime({
		required this.breakId,
		required this.attendanceId,
		required this.employeeId,
		required this.adminId,
		this.breakInTime,
		this.breakOutTime,
		this.breakInPhoto,
		this.breakOutPhoto,
	});

	factory BreakTime.fromJson(Map<String, dynamic> json) {
		return BreakTime(
			breakId: json['break_id'],
			attendanceId: json['attendance_id'],
			employeeId: json['employee_id'],
			adminId: json['admin_id'],
			breakInTime: json['break_in_time'],
			breakOutTime: json['break_out_time'],
			breakInPhoto: json['break_in_photo'],
			breakOutPhoto: json['break_out_photo'],
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'break_id': breakId,
			'attendance_id': attendanceId,
			'employee_id': employeeId,
			'admin_id': adminId,
			'break_in_time': breakInTime,
			'break_out_time': breakOutTime,
			'break_in_photo': breakInPhoto,
			'break_out_photo': breakOutPhoto,
		};
	}
}
