import 'dart:ui';

import 'package:flutter/material.dart';

import '../../models/notification.dart';
import '../../theme/app_theme.dart';

class MyNotificationCard extends StatelessWidget {
  final NotificationModel notification;
  const MyNotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final subtitle = (notification.subtitle ?? '').trim();

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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: const Icon(
                      Icons.notifications,
                      color: kGreen,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: kHeaderTextStyle(
                            context,
                          ).copyWith(fontSize: 18, color: kBrown),
                        ),
                        if (subtitle.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            subtitle,
                            style: kDescriptionTextStyle(context).copyWith(
                              color: kBrown.withAlpha((0.78 * 255).toInt()),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
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
}
