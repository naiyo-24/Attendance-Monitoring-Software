import 'package:flutter/material.dart';
import '../../models/leaves.dart';
import '../../providers/leaves_provider.dart';
import '../../theme/app_theme.dart';
import 'dart:ui';

class LeaveRequestCard extends StatelessWidget {
  final Leave leave;
  const LeaveRequestCard({super.key, required this.leave});

  String _formatDate(DateTime date) {
    final d = date.toLocal();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  @override
  Widget build(BuildContext context) {
    final leavesNotifier = LeavesProvider.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
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
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: kWhiteGrey.withAlpha(170),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: kBlack.withAlpha((0.06 * 255).toInt()),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            leave.employee.name.isEmpty
                                ? '?'
                                : leave.employee.name[0],
                            style: kHeaderTextStyle(
                              context,
                            ).copyWith(fontSize: 18, color: kBrown),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              leave.employee.name,
                              style: kHeaderTextStyle(
                                context,
                              ).copyWith(fontSize: 18, color: kBrown),
                            ),
                            Text(
                              leave.employee.phone,
                              style: kDescriptionTextStyle(context).copyWith(
                                color: kBrown.withAlpha((0.72 * 255).toInt()),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _statusChip(context, leave.status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: kBrown.withAlpha((0.9 * 255).toInt()),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(leave.date),
                        style: kDescriptionTextStyle(
                          context,
                        ).copyWith(color: kBrown, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: kBrown.withAlpha((0.9 * 255).toInt()),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          leave.reason,
                          style: kDescriptionTextStyle(context).copyWith(
                            color: kBrown.withAlpha((0.85 * 255).toInt()),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (leave.status == LeaveStatus.pending)
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: leave.leaveId == null
                                  ? null
                                  : () {
                                      leavesNotifier.updateLeaveStatus(
                                        leaveId: leave.leaveId!,
                                        status: LeaveStatus.approved,
                                      );
                                    },
                              style: kPremiumButtonStyle(context).copyWith(
                                backgroundColor: WidgetStateProperty.all(
                                  kGreen,
                                ),
                              ),
                              child: const Text('Approve'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: leave.leaveId == null
                                  ? null
                                  : () {
                                      leavesNotifier.updateLeaveStatus(
                                        leaveId: leave.leaveId!,
                                        status: LeaveStatus.rejected,
                                      );
                                    },
                              style: kPremiumButtonStyle(context).copyWith(
                                backgroundColor: WidgetStateProperty.all(kPink),
                              ),
                              child: const Text('Reject'),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusChip(BuildContext context, LeaveStatus status) {
    Color color;
    String label;
    switch (status) {
      case LeaveStatus.pending:
        color = kBrown;
        label = 'Pending';
        break;
      case LeaveStatus.approved:
        color = kGreen;
        label = 'Approved';
        break;
      case LeaveStatus.rejected:
        color = kPink;
        label = 'Rejected';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: kTaglineTextStyle(
          context,
        ).copyWith(color: kWhite, fontSize: 12, fontWeight: FontWeight.w900),
      ),
    );
  }
}
