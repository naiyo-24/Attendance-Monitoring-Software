import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../notifiers/location_matrix_notifier.dart';

class MatrixCard extends ConsumerWidget {
  final String latitude;
  final String longitude;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const MatrixCard({
    super.key,
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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: kWhiteGrey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Latitude', style: kTaglineTextStyle(context)),
                  Text(latitude, style: kHeaderTextStyle(context).copyWith(fontSize: 18)),
                  const SizedBox(height: 6),
                  Text('Longitude', style: kTaglineTextStyle(context)),
                  Text(longitude, style: kHeaderTextStyle(context).copyWith(fontSize: 18)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Iconsax.edit, color: kGreen, size: 26),
              onPressed: onEdit,
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Iconsax.trash, color: kerror, size: 26),
              onPressed: onDelete,
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
