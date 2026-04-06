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
    final name = (employee['name'] ?? '').toString();
    final designation = (employee['designation'] ?? '-').toString();
    final phone = (employee['phone'] ?? '-').toString();
    final profilePhoto = employee['profilePhoto']?.toString();

    final photoUrl = (profilePhoto == null || profilePhoto.trim().isEmpty)
        ? null
        : (profilePhoto.startsWith('http')
              ? profilePhoto
              : baseUrl +
                    (profilePhoto.startsWith('/')
                        ? profilePhoto
                        : '/$profilePhoto'));

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: kWhite.withAlpha(78),
            border: Border.all(color: kWhiteGrey, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: kBlack.withAlpha((0.05 * 255).toInt()),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [kWhiteGrey, kWhite],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kBlack.withAlpha((0.06 * 255).toInt()),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.transparent,
                        backgroundImage: photoUrl != null
                            ? NetworkImage(photoUrl)
                            : null,
                        child: photoUrl == null
                            ? Text(
                                name.isNotEmpty
                                    ? name.characters.first.toUpperCase()
                                    : '?',
                                style: kHeaderTextStyle(
                                  context,
                                ).copyWith(fontSize: 20, color: kBlack),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: kHeaderTextStyle(context).copyWith(
                              fontSize: 20,
                              color: kBlack,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Iconsax.user_tag, color: kBrown, size: 16),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  designation,
                                  style: kTaglineTextStyle(context).copyWith(
                                    fontSize: 15,
                                    color: kBrown,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Iconsax.call, color: kGreen, size: 16),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  phone,
                                  style: kDescriptionTextStyle(context)
                                      .copyWith(
                                        color: kBrown,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        _pillIconButton(
                          context,
                          icon: Iconsax.edit_2,
                          tooltip: 'Edit',
                          foreground: kGreen,
                          onTap: onEdit,
                        ),
                        const SizedBox(width: 10),
                        _pillIconButton(
                          context,
                          icon: Iconsax.trash,
                          tooltip: 'Delete',
                          foreground: kerror,
                          onTap: onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: kBlack.withAlpha((0.05 * 255).toInt()),
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 520;
                    final spacing = 10.0;
                    final fieldWidth = isWide
                        ? (constraints.maxWidth - spacing) / 2
                        : constraints.maxWidth;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: 10,
                      children: [
                        SizedBox(
                          width: fieldWidth,
                          child: _infoRow(
                            context,
                            Iconsax.sms,
                            'Email',
                            employee['email'],
                          ),
                        ),
                        SizedBox(
                          width: fieldWidth,
                          child: _infoRow(
                            context,
                            Iconsax.key,
                            'Password',
                            employee['password'],
                          ),
                        ),
                        SizedBox(
                          width: fieldWidth,
                          child: _infoRow(
                            context,
                            Iconsax.bank,
                            'Bank Name',
                            employee['bankName'],
                          ),
                        ),
                        SizedBox(
                          width: fieldWidth,
                          child: _infoRow(
                            context,
                            Iconsax.building_3,
                            'Branch Name',
                            employee['branchName'],
                          ),
                        ),
                        SizedBox(
                          width: fieldWidth,
                          child: _infoRow(
                            context,
                            Iconsax.card,
                            'Account No.',
                            employee['accountNo'],
                          ),
                        ),
                        SizedBox(
                          width: fieldWidth,
                          child: _infoRow(
                            context,
                            Iconsax.code,
                            'IFSC Code',
                            employee['ifsc'],
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth,
                          child: _infoRow(
                            context,
                            Iconsax.location,
                            'Address',
                            employee['address'],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pillIconButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required Color foreground,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Tooltip(
          message: tooltip,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kWhiteGrey.withAlpha(150),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kBlack.withAlpha((0.04 * 255).toInt())),
            ),
            child: Icon(icon, color: foreground, size: 22),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    dynamic value,
  ) {
    final valueText = (value == null || value.toString().trim().isEmpty)
        ? '-'
        : value.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: kBrown, size: 18),
          const SizedBox(width: 10),
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: kCaptionTextStyle(context).copyWith(
                fontSize: 13,
                color: kBrown,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              valueText,
              style: kDescriptionTextStyle(context).copyWith(
                fontSize: 14,
                color: kBlack,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
