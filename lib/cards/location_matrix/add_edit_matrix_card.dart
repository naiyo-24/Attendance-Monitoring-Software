import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
    // To remove the white background above the bottom sheet, ensure you set
    // backgroundColor: Colors.transparent in showModalBottomSheet.
    // This widget itself should not have any top padding or background outside the card.
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420, minHeight: 0, maxHeight: 320),
          decoration: BoxDecoration(
            color: kWhite.withAlpha(95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: kBrown.withAlpha(9),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
            border: Border.all(color: kWhiteGrey, width: 1.5),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 18,
              bottom: MediaQuery.of(context).viewInsets.bottom + 8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: kBrown.withAlpha(18),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(widget.latitude == null ? Iconsax.add : Iconsax.edit, color: kGreen, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      widget.latitude == null ? 'Create Location Matrix' : 'Edit Location Matrix',
                      style: kHeaderTextStyle(context).copyWith(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Iconsax.global, color: kBrown, size: 16),
                              const SizedBox(width: 4),
                              Text('Latitude', style: kTaglineTextStyle(context).copyWith(fontSize: 14)),
                            ],
                          ),
                          Text(
                            _latitude?.toStringAsFixed(6) ?? '-',
                            style: kHeaderTextStyle(context).copyWith(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Iconsax.global, color: kBrown, size: 16),
                              const SizedBox(width: 4),
                              Text('Longitude', style: kTaglineTextStyle(context).copyWith(fontSize: 14)),
                            ],
                          ),
                          Text(
                            _longitude?.toStringAsFixed(6) ?? '-',
                            style: kHeaderTextStyle(context).copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      style: kPremiumButtonStyle(context).copyWith(
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      onPressed: _pickLocation,
                      icon: const Icon(Iconsax.map, size: 18),
                      label: const Text('Pick'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: kPremiumButtonStyle(context),
                    icon: Icon(widget.latitude == null ? Iconsax.add : Iconsax.save_2, size: 18),
                    label: Text(widget.latitude == null ? 'Create' : 'Save'),
                    onPressed: (_latitude != null && _longitude != null)
                        ? () {
                            widget.onSave(
                              _latitude.toString(),
                              _longitude.toString(),
                            );
                          }
                        : null,
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
