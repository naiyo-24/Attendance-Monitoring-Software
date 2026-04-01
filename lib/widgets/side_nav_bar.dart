import 'package:attendance_admin_panel/models/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme.dart';

class SideNavBar extends StatelessWidget {
  final void Function(String route)? onNavigate;
  const SideNavBar({super.key, this.onNavigate, required User adminUser});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kWhite,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: kBlack),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppLogo(size: 66, assetPath: 'assets/logo/attendx24_logo.png'),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Atendx24',
                      style: kHeaderTextStyle(context).copyWith(color: kWhite, fontSize: 24),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Attendance \nMonitoring System',
                      style: kCaptionTextStyle(
                        context,
                      ).copyWith(color: kWhiteGrey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _drawerItem(context, Iconsax.element_3, 'Dashboard', '/dashboard'),
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
          _drawerItem(context, Iconsax.receipt, 'Salary Slip', '/salary-slip'),
          _drawerItem(
            context,
            Iconsax.notification,
            'Notification Management',
            '/notification-management',
          ),
          // _drawerItem(
          //   context,
          //   Iconsax.info_circle,
          //   'Help Center',
          //   '/help-center',
          // ),
          const Divider(),
          _drawerItem(
            context,
            Iconsax.logout,
            'Log Out',
            '/logout',
            color: kPink,
          ),
        ],
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
    return ListTile(
      leading: Icon(icon, color: color ?? kGreen, size: 26),
      title: Text(
        title,
        style: kDescriptionTextStyle(
          context,
        ).copyWith(color: color ?? kBrown, fontWeight: FontWeight.w600),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: kWhiteGrey,
      onTap: () {
        context.go(route);
        if (onNavigate != null) {
          onNavigate!(route);
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      minLeadingWidth: 32,
    );
  }
}
