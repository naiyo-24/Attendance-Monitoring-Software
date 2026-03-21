import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class MatrixCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
