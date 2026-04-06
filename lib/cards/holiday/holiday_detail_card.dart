import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme/app_theme.dart';

class HolidayDetailCard extends StatelessWidget {
  final String occasion;
  final String date;
  final String remarks;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const HolidayDetailCard({
    super.key,
    required this.occasion,
    required this.date,
    required this.remarks,
    required this.onEdit,
    required this.onDelete,
  });

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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        occasion,
                        style: kHeaderTextStyle(context).copyWith(fontSize: 20),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: kGreen, size: 24),
                      onPressed: onEdit,
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: kerror, size: 24),
                      onPressed: onDelete,
                      tooltip: 'Delete',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: kWhiteGrey.withAlpha(170),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: kBlack.withAlpha((0.06 * 255).toInt()),
                        ),
                      ),
                      child: Text(
                        'Date: $date',
                        style: kCaptionTextStyle(
                          context,
                        ).copyWith(fontWeight: FontWeight.w900, color: kBrown),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Remarks',
                  style: kCaptionTextStyle(
                    context,
                  ).copyWith(fontWeight: FontWeight.w900, color: kBrown),
                ),
                const SizedBox(height: 6),
                Text(
                  remarks.isEmpty ? '-' : remarks,
                  style: kDescriptionTextStyle(context).copyWith(
                    color: kBrown.withAlpha((0.72 * 255).toInt()),
                    fontWeight: FontWeight.w700,
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
