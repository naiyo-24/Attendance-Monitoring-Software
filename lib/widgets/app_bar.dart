

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme.dart';


class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const PremiumAppBar({
    required this.title,
    required this.subtitle,
    this.scaffoldKey,
    super.key,
  });



  @override
  Size get preferredSize => const Size.fromHeight(92);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kBlack.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Iconsax.menu_1, color: kBlack, size: 28),
                  splashRadius: 24,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: kHeaderTextStyle(context).copyWith(
                        color: kBlack,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: kTaglineTextStyle(context).copyWith(
                        color: kBrown,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
              // Optionally, add a profile or action icon here for premium look
              // Icon(Iconsax.user, color: kBrown, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}