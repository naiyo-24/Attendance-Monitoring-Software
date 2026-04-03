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
    if (adminId != null && matrixNotifier.matrices.isEmpty && !matrixNotifier.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(locationMatrixNotifierProvider).fetchMatrices(adminId);
      });
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: kWhite.withAlpha(70),
        boxShadow: [
          BoxShadow(
            color: kBrown.withAlpha(7),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: kWhiteGrey, width: 1.5),
        backgroundBlendMode: BlendMode.overlay,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Iconsax.location, color: kGreen, size: 32),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Store $storeNumber',
                        style: kHeaderTextStyle(context).copyWith(
                          fontSize: 20,
                          color: kBrown,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Iconsax.global, color: kBrown, size: 18),
                          const SizedBox(width: 6),
                          Text('Latitude', style: kTaglineTextStyle(context).copyWith(fontSize: 15)),
                        ],
                      ),
                      Text(latitude, style: kHeaderTextStyle(context).copyWith(fontSize: 18)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Iconsax.global, color: kBrown, size: 18),
                          const SizedBox(width: 6),
                          Text('Longitude', style: kTaglineTextStyle(context).copyWith(fontSize: 15)),
                        ],
                      ),
                      Text(longitude, style: kHeaderTextStyle(context).copyWith(fontSize: 18)),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        style: kPremiumButtonStyle(context).copyWith(
                          backgroundColor: WidgetStateProperty.all(kGreen),
                          foregroundColor: WidgetStateProperty.all(kWhiteGrey),
                          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 18)),
                        ),
                        icon: const Icon(Iconsax.location, size: 18),
                        label: const Text('View Location'),
                        onPressed: () async {
                          final lat = double.tryParse(latitude);
                          final lng = double.tryParse(longitude);
                          if (lat != null && lng != null) {
                            final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            }
                          }
                        },
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
                        icon: const Icon(Iconsax.trash, color: kerror, size: 26),
                        onPressed: onDelete,
                        tooltip: 'Delete',
                        splashRadius: 24,
                      ),
                    ],
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
