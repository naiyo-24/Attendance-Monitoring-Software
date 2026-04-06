import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../notifiers/attendance_notifier.dart';
import '../../theme/app_theme.dart';

class FilterCard extends StatefulWidget {
  final int adminId;
  final List<Map<String, dynamic>> employees; // [{id: 1, name: 'John'}, ...]
  final void Function(int employeeId)? onEmployeeSelected;
  const FilterCard({
    required this.adminId,
    required this.employees,
    this.onEmployeeSelected,
    super.key,
  });

  @override
  State<FilterCard> createState() => _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
  int? selectedEmployeeId;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: kWhite.withAlpha(190),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: kBlack.withAlpha((0.06 * 255).toInt()),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: kBlack.withAlpha((0.05 * 255).toInt()),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select employee',
                  style: kHeaderTextStyle(context).copyWith(
                    fontSize: Responsive.fontSize(context, 16),
                    color: kBrown,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  initialValue: selectedEmployeeId,
                  isExpanded: true,
                  hint: Text(
                    'Choose an employee',
                    style: kCaptionTextStyle(context).copyWith(
                      color: kBrown.withAlpha((0.72 * 255).toInt()),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: kWhiteGrey.withAlpha(170),
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      color: kBrown.withAlpha((0.82 * 255).toInt()),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: widget.employees
                      .map(
                        (e) => DropdownMenuItem<int>(
                          value: e['id'] as int?,
                          child: Text(
                            (e['name'] ?? '').toString(),
                            overflow: TextOverflow.ellipsis,
                            style: kCaptionTextStyle(context).copyWith(
                              fontWeight: FontWeight.w900,
                              color: kBrown,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() => selectedEmployeeId = val);
                    if (val != null) {
                      context.read<AttendanceNotifier>().fetchAttendance(
                        widget.adminId,
                        val,
                      );
                      widget.onEmployeeSelected?.call(val);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
