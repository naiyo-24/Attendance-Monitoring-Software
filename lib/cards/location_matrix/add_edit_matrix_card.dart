import 'package:flutter/material.dart';
import '../../screens/location_matrix/map_picker_screen.dart';
import '../../theme/app_theme.dart';

class AddEditMatrixCard extends StatefulWidget {
  final String? latitude;
  final String? longitude;
  final void Function(String lat, String lng) onSave;
  const AddEditMatrixCard({
    super.key,
    this.latitude,
    this.longitude,
    required this.onSave,
  });

  @override
  State<AddEditMatrixCard> createState() => _AddEditMatrixCardState();
}

class _AddEditMatrixCardState extends State<AddEditMatrixCard> {
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _latitude = widget.latitude != null
        ? double.tryParse(widget.latitude!)
        : null;
    _longitude = widget.longitude != null
        ? double.tryParse(widget.longitude!)
        : null;
  }

  Future<void> _pickLocation() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) =>
            // ignore: prefer_const_constructors
            MapPickerScreen(initialLat: _latitude, initialLng: _longitude),
      ),
    );
    if (result != null &&
        result['latitude'] != null &&
        result['longitude'] != null) {
      setState(() {
        _latitude = result['latitude'] as double;
        _longitude = result['longitude'] as double;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.latitude == null
                ? 'Create Location Matrix'
                : 'Edit Location Matrix',
            style: kHeaderTextStyle(context),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Latitude', style: kTaglineTextStyle(context)),
                    Text(
                      _latitude?.toStringAsFixed(6) ?? '-',
                      style: kHeaderTextStyle(context).copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text('Longitude', style: kTaglineTextStyle(context)),
                    Text(
                      _longitude?.toStringAsFixed(6) ?? '-',
                      style: kHeaderTextStyle(context).copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: kPremiumButtonStyle(context).copyWith(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                onPressed: _pickLocation,
                icon: const Icon(Icons.map),
                label: const Text('Pick on Map'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: kPremiumButtonStyle(context),
              onPressed: (_latitude != null && _longitude != null)
                  ? () {
                      widget.onSave(
                        _latitude.toString(),
                        _longitude.toString(),
                      );
                    }
                  : null,
              child: Text(widget.latitude == null ? 'Create' : 'Save'),
            ),
          ),
        ],
      ),
    );
  }
}
