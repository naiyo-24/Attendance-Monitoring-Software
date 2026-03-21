import 'package:flutter/material.dart';
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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: kWhiteGrey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    occasion,
                    style: kHeaderTextStyle(context).copyWith(fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: kGreen, size: 26),
                  onPressed: onEdit,
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: kPink, size: 26),
                  onPressed: onDelete,
                  tooltip: 'Delete',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Date: $date', style: kTaglineTextStyle(context)),
            const SizedBox(height: 8),
            Text('Remarks: $remarks', style: kDescriptionTextStyle(context)),
          ],
        ),
      ),
    );
  }
}
