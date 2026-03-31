enum AttendanceStatus { present, absent }

class Attendance {
	final int attendanceId;
	final int adminId;
	final int employeeId;
	final String date;
	final String? checkInTime;
	final String? checkOutTime;
	final String? checkInPhoto;
	final String? checkOutPhoto;
	final double? checkInLatitude;
	final double? checkInLongitude;
	final double? checkOutLatitude;
	final double? checkOutLongitude;
	final AttendanceStatus status;

	Attendance({
		required this.attendanceId,
		required this.adminId,
		required this.employeeId,
		required this.date,
		this.checkInTime,
		this.checkOutTime,
		this.checkInPhoto,
		this.checkOutPhoto,
		this.checkInLatitude,
		this.checkInLongitude,
		this.checkOutLatitude,
		this.checkOutLongitude,
		required this.status,
	});

	factory Attendance.fromJson(Map<String, dynamic> json) {
		return Attendance(
			attendanceId: json['attendance_id'],
			adminId: json['admin_id'],
			employeeId: json['employee_id'],
			date: json['date'],
			checkInTime: json['check_in_time'],
			checkOutTime: json['check_out_time'],
			checkInPhoto: json['check_in_photo'],
			checkOutPhoto: json['check_out_photo'],
			checkInLatitude: (json['check_in_latitude'] as num?)?.toDouble(),
			checkInLongitude: (json['check_in_longitude'] as num?)?.toDouble(),
			checkOutLatitude: (json['check_out_latitude'] as num?)?.toDouble(),
			checkOutLongitude: (json['check_out_longitude'] as num?)?.toDouble(),
			status: AttendanceStatus.values.firstWhere(
				(e) => e.name == (json['status'] ?? 'absent'),
				orElse: () => AttendanceStatus.absent,
			),
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'attendance_id': attendanceId,
			'admin_id': adminId,
			'employee_id': employeeId,
			'date': date,
			'check_in_time': checkInTime,
			'check_out_time': checkOutTime,
			'check_in_photo': checkInPhoto,
			'check_out_photo': checkOutPhoto,
			'check_in_latitude': checkInLatitude,
			'check_in_longitude': checkInLongitude,
			'check_out_latitude': checkOutLatitude,
			'check_out_longitude': checkOutLongitude,
			'status': status.name,
		};
	}
}
