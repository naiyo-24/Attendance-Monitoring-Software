import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class EmployeeCard extends StatelessWidget {
  final Map<String, dynamic> employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const EmployeeCard({
    super.key,
    required this.employee,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: kBrown.withOpacity(0.1),
                  backgroundImage: employee['profilePhoto'] != null ? NetworkImage(employee['profilePhoto']) : null,
                  child: employee['profilePhoto'] == null
                      ? const Icon(Iconsax.user, color: kBrown, size: 32)
                      : null,
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(employee['name'] ?? '', style: kHeaderTextStyle(context).copyWith(fontSize: 20)),
                      const SizedBox(height: 2),
                      Text(employee['designation'] ?? '', style: kTaglineTextStyle(context)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Iconsax.edit, color: kGreen, size: 26),
                  onPressed: onEdit,
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Iconsax.trash, color: kPink, size: 26),
                  onPressed: onDelete,
                  tooltip: 'Delete',
                ),
              ],
            ),
            const SizedBox(height: 12),
            _infoRow('Phone', employee['phone']),
            _infoRow('Email', employee['email']),
            _infoRow('Password', employee['password']),
            _infoRow('Bank Name', employee['bankName']),
            _infoRow('Branch Name', employee['branchName']),
            _infoRow('Account No.', employee['accountNo']),
            _infoRow('IFSC Code', employee['ifsc']),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            SizedBox(width: 120, child: Text(label, style: kTaglineTextStyle(context))),
            Expanded(child: Text(value ?? '-', style: kDescriptionTextStyle(context))),
          ],
        ),
      ),
    );
  }
}
