import 'package:attendance_admin_panel/widgets/side_nav_bar.dart';
import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../theme/app_theme.dart';
import '../../cards/location_matrix/matrix_card.dart';
import '../../cards/location_matrix/add_edit_matrix_card.dart';

class LocationMatrixScreen extends StatefulWidget {
  const LocationMatrixScreen({super.key});

  @override
  State<LocationMatrixScreen> createState() => _LocationMatrixScreenState();
}

class _LocationMatrixScreenState extends State<LocationMatrixScreen> {
  // Dummy data for now, replace with provider/notifier logic
  List<Map<String, dynamic>> matrices = [
    {'latitude': '22.5726', 'longitude': '88.3639'},
    {'latitude': '28.7041', 'longitude': '77.1025'},
  ];

  void _openAddEditMatrix({int? index}) async {
    // Show modal bottom sheet for add/edit
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddEditMatrixCard(
          latitude: index != null ? matrices[index]['latitude'] : null,
          longitude: index != null ? matrices[index]['longitude'] : null,
          onSave: (lat, lng) {
            setState(() {
              if (index != null) {
                matrices[index] = {'latitude': lat, 'longitude': lng};
              } else {
                matrices.add({'latitude': lat, 'longitude': lng});
              }
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _deleteMatrix(int index) {
    setState(() {
      matrices.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNavBar(), 
      appBar: const PremiumAppBar(
        title: 'Location Matrix',
        subtitle: 'Manage allowed locations',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: kPremiumButtonStyle(context).copyWith(
                  backgroundColor: WidgetStateProperty.all(kGreen),
                  foregroundColor: WidgetStateProperty.all(kWhite),
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 18)),
                  textStyle: WidgetStateProperty.all(
                    kHeaderTextStyle(context).copyWith(fontSize: 18),
                  ),
                ),
                icon: const Icon(Icons.add_location_alt_rounded, size: 26),
                label: const Text('Create Location Matrix'),
                onPressed: () => _openAddEditMatrix(),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: matrices.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) => MatrixCard(
                  latitude: matrices[index]['latitude'],
                  longitude: matrices[index]['longitude'],
                  onEdit: () => _openAddEditMatrix(index: index),
                  onDelete: () => _deleteMatrix(index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
