import 'dart:ui';

import 'package:attendance_admin_panel/models/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme.dart';

class SideNavBar extends StatelessWidget {
  final User adminUser;
  final void Function(String route)? onNavigate;
  const SideNavBar({super.key, this.onNavigate, required this.adminUser});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(26)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(26)),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kWhite, kWhiteGrey],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            kBlack,
                            kGreen,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: kWhite.withAlpha((0.14 * 255).toInt()),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kBlack.withAlpha((0.16 * 255).toInt()),
                            blurRadius: 28,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const AppLogo(
                              size: 62,
                              assetPath: 'assets/logo/attendx24_logo.png',
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AttendX24',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: kHeaderTextStyle(context).copyWith(
                                      color: kWhite,
                                      fontSize: Responsive.fontSize(
                                        context,
                                        22,
                                      ),
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Attendance Monitoring System',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: kCaptionTextStyle(context).copyWith(
                                      color: kWhiteGrey.withAlpha(
                                        (0.92 * 255).toInt(),
                                      ),
                                      fontWeight: FontWeight.w600,
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
              ),
              _drawerItem(
                context,
                Iconsax.element_3,
                'Dashboard',
                '/dashboard',
              ),
              _drawerItem(
                context,
                Iconsax.location,
                'Location Matrix Management',
                '/set-location-matrix',
              ),
              _drawerItem(
                context,
                Iconsax.user_add,
                'Employee Management',
                '/onboard-employees',
              ),
              _drawerItem(
                context,
                Iconsax.location,
                'Location Tracking',
                '/location-tracking',
              ),
              _drawerItem(
                context,
                Iconsax.calendar,
                'Attendance Records',
                '/attendance',
              ),
              _drawerItem(
                context,
                Iconsax.calendar,
                'Holiday List',
                '/holiday-list',
              ),
              _drawerItem(
                context,
                Iconsax.sun_1,
                'Leave Management',
                '/leave-applications',
              ),
              _drawerItem(
                context,
                Iconsax.receipt,
                'Salary Slip',
                '/salary-slip',
              ),
              _drawerItem(
                context,
                Iconsax.notification,
                'Notification Management',
                '/notification-management',
              ),
              _drawerItem(
                context,
                Iconsax.notification,
                'My Notifications',
                '/my-notifications',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                child: Divider(
                  height: 1,
                  color: kBlack.withAlpha((0.08 * 255).toInt()),
                ),
              ),
              _drawerItem(
                context,
                Iconsax.logout,
                'Log Out',
                '/splash',
                color: kerror,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route, {
    Color? color,
  }) {
    final effectiveColor = color ?? kGreen;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: Material(
        color: kWhite.withAlpha(170),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          hoverColor: kWhiteGrey,
          onTap: () {
            context.go(route);
            if (onNavigate != null) {
              onNavigate!(route);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: kBlack.withAlpha((0.06 * 255).toInt()),
                width: 1,
              ),
            ),
            child: ListTile(
              dense: true,
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: effectiveColor.withAlpha((0.12 * 255).toInt()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: effectiveColor, size: 20),
              ),
              title: Text(
                title,
                style: kCaptionTextStyle(
                  context,
                ).copyWith(color: color ?? kBrown, fontWeight: FontWeight.w700),
              ),
              trailing: Icon(
                Iconsax.arrow_right_3,
                size: 18,
                color: kBrown.withAlpha((0.55 * 255).toInt()),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 2,
              ),
              minLeadingWidth: 0,
            ),
          ),
        ),
      ),
    );
  }
}
