import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../notifiers/location_matrix_notifier.dart';

class MatrixCard extends ConsumerWidget {
  final int storeNumber;
  final String latitude;
  final String longitude;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const MatrixCard({
    super.key,
    required this.storeNumber,
    required this.latitude,
    required this.longitude,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final adminId = auth.user?.adminId;
    final matrixNotifier = ref.watch(locationMatrixNotifierProvider);
    // Optionally, fetch matrices for current adminId if needed
    if (adminId != null &&
        matrixNotifier.matrices.isEmpty &&
        !matrixNotifier.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(locationMatrixNotifierProvider).fetchMatrices(adminId);
      });
    }
    Widget coordChip({required String label, required String value}) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: kWhiteGrey.withAlpha(150),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: kBlack.withAlpha((0.05 * 255).toInt())),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.global, color: kBrown, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: kCaptionTextStyle(context).copyWith(
                      color: kBrown.withAlpha((0.78 * 255).toInt()),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: kHeaderTextStyle(context).copyWith(
                  fontSize: Responsive.fontSize(context, 16),
                  color: kBlack,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget actionPill({
      required IconData icon,
      required Color color,
      required String tooltip,
      required VoidCallback onTap,
    }) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha((0.12 * 255).toInt()),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kBlack.withAlpha((0.05 * 255).toInt())),
            ),
            child: Icon(icon, color: color, size: 20, semanticLabel: tooltip),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: kWhite.withAlpha(85),
            boxShadow: [
              BoxShadow(
                color: kBlack.withAlpha((0.05 * 255).toInt()),
                blurRadius: 26,
                offset: const Offset(0, 12),
              ),
            ],
            border: Border.all(color: kWhiteGrey, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: kGreen.withAlpha((0.12 * 255).toInt()),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Iconsax.location,
                        color: kGreen,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Store $storeNumber',
                        style: kHeaderTextStyle(context).copyWith(
                          fontSize: Responsive.fontSize(context, 18),
                          color: kBlack,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    actionPill(
                      icon: Iconsax.edit_2,
                      color: kGreen,
                      tooltip: 'Edit',
                      onTap: onEdit,
                    ),
                    const SizedBox(width: 10),
                    actionPill(
                      icon: Iconsax.trash,
                      color: kerror,
                      tooltip: 'Delete',
                      onTap: onDelete,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    coordChip(label: 'Latitude', value: latitude),
                    const SizedBox(width: 12),
                    coordChip(label: 'Longitude', value: longitude),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: kPremiumButtonStyle(context).copyWith(
                      backgroundColor: WidgetStateProperty.all(kGreen),
                      foregroundColor: WidgetStateProperty.all(kWhite),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 18,
                        ),
                      ),
                    ),
                    icon: const Icon(Iconsax.location, size: 18),
                    label: const Text('View Location'),
                    onPressed: () async {
                      final lat = double.tryParse(latitude);
                      final lng = double.tryParse(longitude);
                      if (lat != null && lng != null) {
                        final url = Uri.parse(
                          'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
