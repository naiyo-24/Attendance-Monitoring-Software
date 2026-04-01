import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:provider/provider.dart';

import '../../notifiers/auth_notifier.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';


class MapPickerScreen extends StatefulWidget {
  static const String routeName = '/pick-location';
  final double? initialLat;
  final double? initialLng;
  const MapPickerScreen({super.key, this.initialLat, this.initialLng});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLong? pickedLocation;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      drawer: SideNavBar(adminUser: auth.user!),
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
        child: FlutterLocationPicker(
          userAgent: 'AttendanceApp/1.0.0 (contact@yourdomain.com)',
          initPosition: widget.initialLat != null && widget.initialLng != null
              ? LatLong(widget.initialLat!, widget.initialLng!)
              : const LatLong(22.5667, 88.3667), // Kolkata Esplanade
          showCurrentLocationPointer: true,
          onPicked: (pickedData) {
            setState(() {
              pickedLocation = pickedData.latLong;
            });
          },
        ),
      ),
      floatingActionButton: pickedLocation != null
          ? FloatingActionButton.extended(
              backgroundColor: kGreen,
              foregroundColor: kWhite,
              onPressed: () {
                Navigator.of(context).pop({
                  'latitude': pickedLocation!.latitude,
                  'longitude': pickedLocation!.longitude,
                });
              },
              label: const Text('Select Location'),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }
}
