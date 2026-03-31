import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/attendance.dart';

import '../../notifiers/attendance_notifier.dart';
import '../../services/api_url.dart';

class AttendanceDetailsCard extends StatelessWidget {
	final Attendance attendance;
	final int adminId;
	const AttendanceDetailsCard({required this.attendance, required this.adminId, super.key});

	@override
	Widget build(BuildContext context) {
		String? checkInPhotoUrl = attendance.checkInPhoto != null && attendance.checkInPhoto!.isNotEmpty
				? (attendance.checkInPhoto!.startsWith('http') ? attendance.checkInPhoto! : baseUrl + '/' + attendance.checkInPhoto!)
				: null;
		String? checkOutPhotoUrl = attendance.checkOutPhoto != null && attendance.checkOutPhoto!.isNotEmpty
				? (attendance.checkOutPhoto!.startsWith('http') ? attendance.checkOutPhoto! : baseUrl + '/' + attendance.checkOutPhoto!)
				: null;

		return Padding(
			padding: EdgeInsets.only(
				left: 16,
				right: 16,
				top: 24,
				bottom: MediaQuery.of(context).viewInsets.bottom + 24,
			),
			child: SingleChildScrollView(
				child: Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text('Date: ${attendance.date}', style: const TextStyle(fontWeight: FontWeight.bold)),
						const SizedBox(height: 8),
						Row(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Expanded(child: Text('Check-in: ${attendance.checkInTime ?? '-'}')),
								if (checkInPhotoUrl != null)
									Flexible(
										child: Padding(
											padding: const EdgeInsets.only(left: 8.0),
											child: Image.network(
												checkInPhotoUrl,
												width: 64,
												height: 64,
												fit: BoxFit.cover,
												errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 48),
											),
										),
									),
							],
						),
						const SizedBox(height: 8),
						Row(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Expanded(child: Text('Check-out: ${attendance.checkOutTime ?? '-'}')),
								if (checkOutPhotoUrl != null)
									Flexible(
										child: Padding(
											padding: const EdgeInsets.only(left: 8.0),
											child: Image.network(
												checkOutPhotoUrl,
												width: 64,
												height: 64,
												fit: BoxFit.cover,
												errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 48),
											),
										),
									),
							],
						),
						const SizedBox(height: 16),
						Row(
							children: [
								Expanded(
									child: ElevatedButton(
										style: ElevatedButton.styleFrom(
											backgroundColor: attendance.status == AttendanceStatus.present ? Colors.green : null,
										),
										onPressed: attendance.status == AttendanceStatus.present
												? null
												: () async {
														await context.read<AttendanceNotifier>().updateAttendanceStatus(
															attendanceId: attendance.attendanceId,
															adminId: adminId,
															status: AttendanceStatus.present,
														);
														Navigator.pop(context);
													},
										child: const Text('Mark as Present'),
									),
								),
								const SizedBox(width: 12),
								Expanded(
									child: ElevatedButton(
										style: ElevatedButton.styleFrom(
											backgroundColor: attendance.status == AttendanceStatus.absent ? Colors.red : null,
										),
										onPressed: attendance.status == AttendanceStatus.absent
												? null
												: () async {
														await context.read<AttendanceNotifier>().updateAttendanceStatus(
															attendanceId: attendance.attendanceId,
															adminId: adminId,
															status: AttendanceStatus.absent,
														);
														Navigator.pop(context);
													},
										child: const Text('Mark as Absent'),
									),
								),
							],
						),
					],
				),
			),
		);
	}
}
