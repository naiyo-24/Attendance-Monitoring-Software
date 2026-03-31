import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/attendance.dart';

import '../../notifiers/attendance_notifier.dart';
import '../../services/api_url.dart';
import '../../theme/app_theme.dart';

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

		return Center(
			child: Container(
				constraints: const BoxConstraints(maxWidth: 420),
				decoration: BoxDecoration(
					color: kWhite,
					borderRadius: BorderRadius.circular(24),
					boxShadow: [
						BoxShadow(
							color: kBrown.withOpacity(0.08),
							blurRadius: 24,
							offset: const Offset(0, 8),
						),
					],
				),
				child: Padding(
					padding: EdgeInsets.only(
						left: 24,
						right: 24,
						top: 28,
						bottom: MediaQuery.of(context).viewInsets.bottom + 28,
					),
					child: SingleChildScrollView(
						child: Column(
							mainAxisSize: MainAxisSize.min,
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text('Date: ${attendance.date}', style: kHeaderTextStyle(context).copyWith(fontSize: 18)),
								const SizedBox(height: 12),
								Row(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Expanded(child: Text('Check-in: ${attendance.checkInTime ?? '-'}', style: kDescriptionTextStyle(context))),
										if (checkInPhotoUrl != null)
											ClipRRect(
												borderRadius: BorderRadius.circular(12),
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
								const SizedBox(height: 12),
								Row(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Expanded(child: Text('Check-out: ${attendance.checkOutTime ?? '-'}', style: kDescriptionTextStyle(context))),
										if (checkOutPhotoUrl != null)
											ClipRRect(
												borderRadius: BorderRadius.circular(12),
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
								const SizedBox(height: 24),
								Row(
									children: [
										Expanded(
											child: ElevatedButton(
												style: kPremiumButtonStyle(context).copyWith(
													backgroundColor: MaterialStateProperty.all(
														attendance.status == AttendanceStatus.present ? Colors.green : kGreen,
													),
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
										const SizedBox(width: 16),
										Expanded(
											child: ElevatedButton(
												style: kPremiumButtonStyle(context).copyWith(
													backgroundColor: MaterialStateProperty.all(
														attendance.status == AttendanceStatus.absent ? Colors.red : kerror,
													),
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
				),
			),
		);
	}
}
