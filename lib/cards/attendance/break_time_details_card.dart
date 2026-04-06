import 'dart:ui';

import 'package:flutter/material.dart';
import '../../models/break_time.dart';
import '../../services/api_url.dart';
import '../../theme/app_theme.dart';
import '../../utils/attendance_ist_time.dart';

class BreakTimeDetailsCard extends StatelessWidget {
  final List<BreakTime> breaks;
  const BreakTimeDetailsCard({required this.breaks, super.key});

  String _formatIstTime(BuildContext context, String? value) {
    final alwaysUse24Hour = MediaQuery.of(context).alwaysUse24HourFormat;
    return formatIstTime(value, use24Hour: alwaysUse24Hour, showSeconds: true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            decoration: BoxDecoration(
              color: kWhite.withAlpha(220),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: kBlack.withAlpha((0.06 * 255).toInt()),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: kBlack.withAlpha((0.10 * 255).toInt()),
                  blurRadius: 26,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
              child: SingleChildScrollView(
                child: breaks.isEmpty
                    ? Center(
                        child: Text(
                          'No breaks taken on this day.',
                          textAlign: TextAlign.center,
                          style: kCaptionTextStyle(context).copyWith(
                            fontWeight: FontWeight.w800,
                            color: kBrown.withAlpha((0.74 * 255).toInt()),
                          ),
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: kWhiteGrey.withAlpha(170),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: kBlack.withAlpha(
                                      (0.06 * 255).toInt(),
                                    ),
                                  ),
                                ),
                                child: Icon(
                                  Icons.coffee_outlined,
                                  color: kGreen,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Breaks Taken',
                                  style: kHeaderTextStyle(
                                    context,
                                  ).copyWith(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...breaks.map(
                            (b) => Padding(
                              padding: const EdgeInsets.only(bottom: 14.0),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: kWhiteGrey.withAlpha(170),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: kBlack.withAlpha(
                                      (0.06 * 255).toInt(),
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Break In: ${_formatIstTime(context, b.breakInTime)}',
                                            style:
                                                kDescriptionTextStyle(
                                                  context,
                                                ).copyWith(
                                                  color: kBrown,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                        if (b.breakInPhoto != null &&
                                            b.breakInPhoto!.isNotEmpty)
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.network(
                                              b.breakInPhoto!.startsWith('http')
                                                  ? b.breakInPhoto!
                                                  : '$baseUrl/${b.breakInPhoto!}',
                                              width: 62,
                                              height: 62,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons.broken_image,
                                                    size: 40,
                                                  ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Break Out: ${_formatIstTime(context, b.breakOutTime)}',
                                            style:
                                                kDescriptionTextStyle(
                                                  context,
                                                ).copyWith(
                                                  color: kBrown,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                        if (b.breakOutPhoto != null &&
                                            b.breakOutPhoto!.isNotEmpty)
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.network(
                                              b.breakOutPhoto!.startsWith(
                                                    'http',
                                                  )
                                                  ? b.breakOutPhoto!
                                                  : '$baseUrl/${b.breakOutPhoto!}',
                                              width: 62,
                                              height: 62,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons.broken_image,
                                                    size: 40,
                                                  ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
