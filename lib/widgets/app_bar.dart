import 'dart:ui';

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: kWhite.withAlpha(210),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: kBlack.withAlpha((0.06 * 255).toInt()),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: kBlack.withAlpha((0.06 * 255).toInt()),
                    blurRadius: 26,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Builder(
                      builder: (context) => Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            if (scaffoldKey?.currentState != null) {
                              scaffoldKey!.currentState!.openDrawer();
                              return;
                            }
                            Scaffold.of(context).openDrawer();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: kWhiteGrey.withAlpha(160),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: kBlack.withAlpha((0.05 * 255).toInt()),
                              ),
                            ),
                            child: const Icon(
                              Iconsax.menu_1,
                              color: kBlack,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kHeaderTextStyle(context).copyWith(
                              color: kBlack,
                              fontSize: Responsive.fontSize(context, 22),
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kCaptionTextStyle(context).copyWith(
                              color: kBrown.withAlpha((0.80 * 255).toInt()),
                              fontWeight: FontWeight.w700,
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
    );
  }
}
