import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AttendX24Loader extends StatelessWidget {
  final String text;
  final double logoSize;

  const AttendX24Loader({
    super.key,
    this.text = 'Loading, please wait…',
    this.logoSize = 72,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: text,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: logoSize + 28,
              height: logoSize + 28,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: kBlack.withAlpha((0.06 * 255).toInt()),
                  width: 1.2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: ColoredBox(
                  color: kWhiteGrey.withAlpha(80),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/logo/attendx24_logo.png',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.6,
                valueColor: AlwaysStoppedAnimation<Color>(
                  kBlack.withAlpha((0.65 * 255).toInt()),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: kCaptionTextStyle(context).copyWith(
                color: kBrown.withAlpha((0.78 * 255).toInt()),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
