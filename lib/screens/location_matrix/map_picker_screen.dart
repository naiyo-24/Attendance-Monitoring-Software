import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/loader.dart';
import '../../widgets/side_nav_bar.dart';

class MapPickerScreen extends ConsumerStatefulWidget {
  static const String routeName = '/pick-location';
  final double? initialLat;
  final double? initialLng;
  const MapPickerScreen({super.key, this.initialLat, this.initialLng});

  @override
  ConsumerState<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends ConsumerState<MapPickerScreen> {
  LatLong? pickedLocation;
  bool _booting = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _booting = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final showLoader = auth.isLoading || _booting;
    return Scaffold(
      drawer: auth.user == null ? null : SideNavBar(adminUser: auth.user!),
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            child: showLoader
                ? const AttendX24Loader(text: 'Loading map…')
                : ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhite.withAlpha(210),
                        borderRadius: BorderRadius.circular(24),
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
                      child: FlutterLocationPicker(
                        userAgent:
                            'AttendanceApp/1.0.0 (contact@yourdomain.com)',
                        initPosition:
                            widget.initialLat != null &&
                                widget.initialLng != null
                            ? LatLong(widget.initialLat!, widget.initialLng!)
                            : const LatLong(22.5667, 88.3667),
                        showCurrentLocationPointer: true,
                        onPicked: (pickedData) {
                          setState(() {
                            pickedLocation = pickedData.latLong;
                          });
                        },
                      ),
                    ),
                  ),
          ),
        ),
      ),
      floatingActionButton: pickedLocation != null && !showLoader
          ? FloatingActionButton.extended(
              backgroundColor: kGreen,
              foregroundColor: kWhite,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              onPressed: () {
                Navigator.of(context).pop({
                  'latitude': pickedLocation!.latitude,
                  'longitude': pickedLocation!.longitude,
                });
              },
              label: Text(
                'Select Location',
                style: kCaptionTextStyle(
                  context,
                ).copyWith(color: kWhite, fontWeight: FontWeight.w800),
              ),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }
}
