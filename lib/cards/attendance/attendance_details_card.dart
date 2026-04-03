import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/attendance.dart';

import '../../notifiers/attendance_notifier.dart';
import '../../services/api_url.dart';

import '../../theme/app_theme.dart';
import 'break_time_details_card.dart';
import '../../services/break_time_services.dart';
import '../../models/break_time.dart';

class AttendanceDetailsCard extends StatelessWidget {
  final Attendance attendance;
  final int adminId;
  const AttendanceDetailsCard({
    required this.attendance,
    required this.adminId,
    super.key,
  });

  DateTime? _tryParseDateTime(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return null;
    return DateTime.tryParse(v);
  }

  TimeOfDay? _tryParseTimeOfDay(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return null;
    final match = RegExp(r'^(\d{1,2}):(\d{2})(?::\d{2})?$').firstMatch(v);
    if (match == null) return null;
    final hour = int.tryParse(match.group(1) ?? '');
    final minute = int.tryParse(match.group(2) ?? '');
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatLocalDate(BuildContext context, String? value) {
    final dt = _tryParseDateTime(value);
    if (dt == null)
      return value?.trim().isNotEmpty == true ? value!.trim() : '-';
    final local = dt.toLocal();
    final dateOnly = DateTime(local.year, local.month, local.day);
    return MaterialLocalizations.of(context).formatFullDate(dateOnly);
  }

  String _formatLocalTime(BuildContext context, String? value) {
    final dt = _tryParseDateTime(value);
    final localizations = MaterialLocalizations.of(context);
    final alwaysUse24Hour = MediaQuery.of(context).alwaysUse24HourFormat;
    if (dt != null) {
      final local = dt.toLocal();
      return localizations.formatTimeOfDay(
        TimeOfDay.fromDateTime(local),
        alwaysUse24HourFormat: alwaysUse24Hour,
      );
    }
    final time = _tryParseTimeOfDay(value);
    if (time != null) {
      return localizations.formatTimeOfDay(
        time,
        alwaysUse24HourFormat: alwaysUse24Hour,
      );
    }
    return value?.trim().isNotEmpty == true ? value!.trim() : '-';
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

    final attendanceDate = _tryParseDateTime(attendance.date)?.toLocal();

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: kBrown.withAlpha(8),
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
                Text(
                  'Date: ${_formatLocalDate(context, attendance.date)}',
                  style: kHeaderTextStyle(context).copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Check-in: ${_formatLocalTime(context, attendance.checkInTime)}',
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
                        'Check-out: ${_formatLocalTime(context, attendance.checkOutTime)}',
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
                                ? Colors.green
                                : kGreen,
                          ),
                        ),
                        onPressed: attendance.status == AttendanceStatus.present
                            ? null
                            : () async {
                                final notifier = context
                                    .read<AttendanceNotifier>();
                                final navigator = Navigator.of(context);
                                await notifier.updateAttendanceStatus(
                                  attendanceId: attendance.attendanceId,
                                  adminId: adminId,
                                  status: AttendanceStatus.present,
                                );
                                navigator.pop();
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
                                ? Colors.red
                                : kerror,
                          ),
                        ),
                        onPressed: attendance.status == AttendanceStatus.absent
                            ? null
                            : () async {
                                final notifier = context
                                    .read<AttendanceNotifier>();
                                final navigator = Navigator.of(context);
                                await notifier.updateAttendanceStatus(
                                  attendanceId: attendance.attendanceId,
                                  adminId: adminId,
                                  status: AttendanceStatus.absent,
                                );
                                navigator.pop();
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
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Text(
                                    'Failed to load breaks',
                                    style: TextStyle(color: kerror),
                                  ),
                                ),
                              );
                            }
                            final breaks = snapshot.data ?? [];
                            final date =
                                attendanceDate ??
                                DateTime.tryParse(attendance.date) ??
                                DateTime.parse(attendance.date);
                            final dayBreaks = breaks.where((b) {
                              final breakIn = _tryParseDateTime(
                                b.breakInTime,
                              )?.toLocal();
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
    );
  }
}
