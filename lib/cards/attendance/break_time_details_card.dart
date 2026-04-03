import 'package:flutter/material.dart';
import '../../models/break_time.dart';
import '../../services/api_url.dart';
import '../../theme/app_theme.dart';

class BreakTimeDetailsCard extends StatelessWidget {
  final List<BreakTime> breaks;
  const BreakTimeDetailsCard({required this.breaks, super.key});

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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: SingleChildScrollView(
            child: breaks.isEmpty
                ? Center(
                    child: Text(
                      'No breaks taken on this day.',
                      style: kDescriptionTextStyle(context),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Breaks Taken',
                        style: kHeaderTextStyle(context).copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      ...breaks.map(
                        (b) => Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Break In: ${_formatLocalTime(context, b.breakInTime)}',
                                      style: kDescriptionTextStyle(context),
                                    ),
                                  ),
                                  if (b.breakInPhoto != null &&
                                      b.breakInPhoto!.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                        ),
                                        child: Image.network(
                                          b.breakInPhoto!.startsWith('http')
                                              ? b.breakInPhoto!
                                              : '$baseUrl/${b.breakInPhoto!}',
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.broken_image,
                                                    size: 40,
                                                  ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Break Out: ${_formatLocalTime(context, b.breakOutTime)}',
                                      style: kDescriptionTextStyle(context),
                                    ),
                                  ),
                                  if (b.breakOutPhoto != null &&
                                      b.breakOutPhoto!.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                        ),
                                        child: Image.network(
                                          b.breakOutPhoto!.startsWith('http')
                                              ? b.breakOutPhoto!
                                              : '$baseUrl/${b.breakOutPhoto!}',
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.broken_image,
                                                    size: 40,
                                                  ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
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
