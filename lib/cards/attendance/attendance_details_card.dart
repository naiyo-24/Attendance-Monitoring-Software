import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/attendance.dart';

import '../../notifiers/attendance_notifier.dart';
import '../../services/api_url.dart';

import '../../theme/app_theme.dart';
import 'break_time_details_card.dart';
import '../../services/break_time_services.dart';
import '../../models/break_time.dart';
import '../../widgets/loader.dart';
import '../../utils/attendance_ist_time.dart';

class AttendanceDetailsCard extends StatelessWidget {
  final Attendance attendance;
  final int adminId;
  const AttendanceDetailsCard({
    required this.attendance,
    required this.adminId,
    super.key,
  });

  String _formatIstDate(BuildContext context, String? value) {
    final dt = tryParseApiDateTimeAsIst(value);
    if (dt == null) {
      return value?.trim().isNotEmpty == true ? value!.trim() : '-';
    }
    final dateOnly = DateTime(dt.year, dt.month, dt.day);
    return MaterialLocalizations.of(context).formatFullDate(dateOnly);
  }

  String _formatIstTime(BuildContext context, String? value) {
    final alwaysUse24Hour = MediaQuery.of(context).alwaysUse24HourFormat;
    return formatIstTime(value, use24Hour: alwaysUse24Hour, showSeconds: true);
  }

  @override
  Widget build(BuildContext context) {
    String? checkInPhotoUrl =
        attendance.checkInPhoto != null && attendance.checkInPhoto!.isNotEmpty
        ? (attendance.checkInPhoto!.startsWith('http')
              ? attendance.checkInPhoto!
              : '$baseUrl/${attendance.checkInPhoto!}')
        : null;
    String? checkOutPhotoUrl =
        attendance.checkOutPhoto != null && attendance.checkOutPhoto!.isNotEmpty
        ? (attendance.checkOutPhoto!.startsWith('http')
              ? attendance.checkOutPhoto!
              : '$baseUrl/${attendance.checkOutPhoto!}')
        : null;

    final attendanceDate = tryParseApiDateTimeAsIst(attendance.date);

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            decoration: BoxDecoration(
              color: kWhite.withAlpha(220),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: kBlack.withAlpha((0.06 * 255).toInt()),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: kBlack.withAlpha((0.10 * 255).toInt()),
                  blurRadius: 26,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 26,
                bottom: MediaQuery.of(context).viewInsets.bottom + 26,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ${_formatIstDate(context, attendance.date)}',
                      style: kHeaderTextStyle(context).copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Check-in: ${_formatIstTime(context, attendance.checkInTime)}',
                            style: kDescriptionTextStyle(context),
                          ),
                        ),
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
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 48),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Check-out: ${_formatIstTime(context, attendance.checkOutTime)}',
                            style: kDescriptionTextStyle(context),
                          ),
                        ),
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
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 48),
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
                              backgroundColor: WidgetStateProperty.all(
                                attendance.status == AttendanceStatus.present
                                    ? kGreen.withAlpha(220)
                                    : kGreen,
                              ),
                              foregroundColor: WidgetStateProperty.all(kWhite),
                            ),
                            onPressed:
                                attendance.status == AttendanceStatus.present
                                ? null
                                : () async {
                                    final notifier = context
                                        .read<AttendanceNotifier>();
                                    final ok = await notifier
                                        .updateAttendanceStatus(
                                          attendanceId: attendance.attendanceId,
                                          adminId: adminId,
                                          status: AttendanceStatus.present,
                                        );
                                    if (!context.mounted) return;
                                    if (ok) Navigator.of(context).pop();
                                  },
                            child: const Text('Mark as Present'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: kPremiumButtonStyle(context).copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                attendance.status == AttendanceStatus.absent
                                    ? kerror.withAlpha(220)
                                    : kerror,
                              ),
                              foregroundColor: WidgetStateProperty.all(kWhite),
                            ),
                            onPressed:
                                attendance.status == AttendanceStatus.absent
                                ? null
                                : () async {
                                    final notifier = context
                                        .read<AttendanceNotifier>();
                                    final ok = await notifier
                                        .updateAttendanceStatus(
                                          attendanceId: attendance.attendanceId,
                                          adminId: adminId,
                                          status: AttendanceStatus.absent,
                                        );
                                    if (!context.mounted) return;
                                    if (ok) Navigator.of(context).pop();
                                  },
                            child: const Text('Mark as Absent'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kBrown,
                          side: BorderSide(color: kBrown.withAlpha(4)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          textStyle: kDescriptionTextStyle(
                            context,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => FutureBuilder<List<BreakTime>>(
                              future: BreakTimeService()
                                  .fetchBreaksByAdminAndEmployee(
                                    adminId,
                                    attendance.employeeId,
                                  ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: AttendX24Loader(
                                      text: 'Loading breaks…',
                                    ),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(32.0),
                                      child: Text(
                                        'Failed to load breaks',
                                        textAlign: TextAlign.center,
                                        style: kCaptionTextStyle(context)
                                            .copyWith(
                                              color: kerror,
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                    ),
                                  );
                                }
                                final breaks = snapshot.data ?? [];
                                final date =
                                    attendanceDate ??
                                    tryParseApiDateTimeAsIst(attendance.date) ??
                                    DateTime.tryParse(attendance.date) ??
                                    DateTime.parse(attendance.date);
                                final dayBreaks = breaks.where((b) {
                                  final breakIn = tryParseApiDateTimeAsIst(
                                    b.breakInTime,
                                  );
                                  if (breakIn == null) return false;
                                  return breakIn.year == date.year &&
                                      breakIn.month == date.month &&
                                      breakIn.day == date.day;
                                }).toList();
                                return BreakTimeDetailsCard(breaks: dayBreaks);
                              },
                            ),
                          );
                        },
                        child: const Text('View Breaks Taken'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
