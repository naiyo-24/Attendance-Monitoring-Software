import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../services/api_url.dart';
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: kWhite.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: kBrown.withOpacity(0.07),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: kWhiteGrey, width: 1.5),
        // Glassmorphism effect
        backgroundBlendMode: BlendMode.overlay,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [kWhiteGrey, kWhite],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kBrown.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.transparent,
                        backgroundImage: employee['profilePhoto'] != null
                            ? NetworkImage(
                                employee['profilePhoto'].toString().startsWith('http')
                                    ? employee['profilePhoto']
                                    : baseUrl + (employee['profilePhoto'].toString().startsWith('/') ? employee['profilePhoto'] : '/${employee['profilePhoto']}')
                              )
                            : null,
                        child: employee['profilePhoto'] == null
                            ? const Icon(Iconsax.user, color: kBrown, size: 36)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 22),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            employee['name'] ?? '',
                            style: kHeaderTextStyle(context).copyWith(fontSize: 22, color: kBrown),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Iconsax.user_tag, color: kGreen, size: 18),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  employee['designation'] ?? '-',
                                  style: kTaglineTextStyle(context).copyWith(fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Iconsax.edit_2, color: kGreen, size: 26),
                            onPressed: onEdit,
                            tooltip: 'Edit',
                            splashRadius: 24,
                          ),
                          IconButton(
                            icon: const Icon(Iconsax.trash, color: kPink, size: 26),
                            onPressed: onDelete,
                            tooltip: 'Delete',
                            splashRadius: 24,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  runSpacing: 8,
                  children: [
                    _infoRow(context, Iconsax.call, 'Phone', employee['phone']),
                    _infoRow(context, Iconsax.sms, 'Email', employee['email']),
                    _infoRow(context, Iconsax.key, 'Password', employee['password']),
                    _infoRow(context, Iconsax.bank, 'Bank Name', employee['bankName']),
                    _infoRow(context, Iconsax.building_3, 'Branch Name', employee['branchName']),
                    _infoRow(context, Iconsax.card, 'Account No.', employee['accountNo']),
                    _infoRow(context, Iconsax.code, 'IFSC Code', employee['ifsc']),
                    _infoRow(context, Iconsax.location, 'Address', employee['address']),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: kBrown, size: 18),
          const SizedBox(width: 8),
          SizedBox(width: 110, child: Text(label, style: kTaglineTextStyle(context).copyWith(fontSize: 15))),
          Expanded(
            child: Text(
              value ?? '-',
              style: kDescriptionTextStyle(context).copyWith(fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
