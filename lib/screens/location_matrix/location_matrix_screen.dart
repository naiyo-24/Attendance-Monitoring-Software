import 'package:attendance_admin_panel/widgets/side_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/location_matrix.dart';
import '../../widgets/app_bar.dart';
import '../../theme/app_theme.dart';
import '../../cards/location_matrix/matrix_card.dart';
import '../../cards/location_matrix/add_edit_matrix_card.dart';
import '../../notifiers/location_matrix_notifier.dart';
import '../../providers/auth_provider.dart';

class LocationMatrixScreen extends ConsumerStatefulWidget {
  const LocationMatrixScreen({super.key});

  @override
  ConsumerState<LocationMatrixScreen> createState() => _LocationMatrixScreenState();
}

class _LocationMatrixScreenState extends ConsumerState<LocationMatrixScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final adminId = auth.user?.adminId;
    final matrixNotifier = ref.watch(locationMatrixNotifierProvider);
    if (adminId != null && matrixNotifier.matrices.isEmpty && !matrixNotifier.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(locationMatrixNotifierProvider).fetchMatrices(adminId);
      });
    }
    void openAddEditMatrix({int? index}) async {
      final matrix = index != null ? matrixNotifier.matrices[index] : null;
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => AddEditMatrixCard(
          latitude: matrix?.latitude.toString(),
          longitude: matrix?.longitude.toString(),
          onSave: (lat, lng) async {
            if (adminId == null) return;
            if (index != null && matrix != null) {
              await ref.read(locationMatrixNotifierProvider).updateMatrix(
                LocationMatrix(
                  locationMatrixId: matrix.locationMatrixId,
                  adminId: adminId,
                  latitude: double.tryParse(lat) ?? 0.0,
                  longitude: double.tryParse(lng) ?? 0.0,
                ),
                adminId,
              );
            } else {
              await ref.read(locationMatrixNotifierProvider).addMatrix(
                LocationMatrix(
                  adminId: adminId,
                  latitude: double.tryParse(lat) ?? 0.0,
                  longitude: double.tryParse(lng) ?? 0.0,
                ),
              );
            }
            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
        ),
      );
    }
    void deleteMatrix(int index) async {
      if (adminId == null) return;
      final matrix = matrixNotifier.matrices[index];
      if (matrix.locationMatrixId != null) {
        await ref.read(locationMatrixNotifierProvider).deleteMatrix(matrix.locationMatrixId!, adminId);
      }
    }
    return Scaffold(
      drawer:  SideNavBar(adminUser: ref.watch(authProvider).user!),
      appBar: const PremiumAppBar(
        title: 'Location Matrix',
        subtitle: 'Manage allowed locations',
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kWhite, kWhiteGrey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: kPremiumButtonStyle(context).copyWith(
                          backgroundColor: WidgetStateProperty.all(kGreen),
                          foregroundColor: WidgetStateProperty.all(kWhite),
                          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 20)),
                          textStyle: WidgetStateProperty.all(
                            kHeaderTextStyle(context).copyWith(fontSize: 18),
                          ),
                          elevation: WidgetStateProperty.all(6),
                        ),
                        icon: const Icon(Iconsax.add, size: 26),
                        label: const Text('Create Location Matrix'),
                        onPressed: () => openAddEditMatrix(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: matrixNotifier.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                        itemCount: matrixNotifier.matrices.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final matrix = matrixNotifier.matrices[index];
                          return MatrixCard(
                            latitude: matrix.latitude.toString(),
                            longitude: matrix.longitude.toString(),
                            onEdit: () => openAddEditMatrix(index: index),
                            onDelete: () => deleteMatrix(index),
                          );
                        },
                      ),
              ),
              if (matrixNotifier.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    matrixNotifier.error!,
                    style: TextStyle(color: kerror),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
