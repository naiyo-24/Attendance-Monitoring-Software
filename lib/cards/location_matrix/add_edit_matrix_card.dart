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
    final isCreate = widget.latitude == null;

    Widget coordLine({required String label, required String value}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: kWhiteGrey.withAlpha(150),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kBlack.withAlpha((0.05 * 255).toInt())),
        ),
        child: Row(
          children: [
            const Icon(Iconsax.global, color: kBrown, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: kCaptionTextStyle(context).copyWith(
                      color: kBrown.withAlpha((0.78 * 255).toInt()),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
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
          ],
        ),
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 520,
            maxHeight: MediaQuery.of(context).size.height * 0.70,
          ),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: kBlack.withAlpha((0.10 * 255).toInt()),
                blurRadius: 40,
                offset: const Offset(0, -6),
              ),
            ],
            border: Border.all(color: kWhiteGrey, width: 1.5),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 22,
              right: 22,
              top: 14,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
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
                      color: kBlack.withAlpha((0.10 * 255).toInt()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kWhiteGrey.withAlpha(140),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: kBlack.withAlpha((0.04 * 255).toInt()),
                        ),
                      ),
                      child: Icon(
                        isCreate ? Iconsax.add : Iconsax.edit,
                        color: kBlack,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isCreate
                          ? 'Create Location Matrix'
                          : 'Edit Location Matrix',
                      style: kHeaderTextStyle(context).copyWith(
                        fontSize: Responsive.fontSize(context, 20),
                        color: kBlack,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                coordLine(
                  label: 'Latitude',
                  value: _latitude?.toStringAsFixed(6) ?? '-',
                ),
                const SizedBox(height: 12),
                coordLine(
                  label: 'Longitude',
                  value: _longitude?.toStringAsFixed(6) ?? '-',
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: kPremiumButtonStyle(context).copyWith(
                      backgroundColor: WidgetStateProperty.all(kWhiteGrey),
                      foregroundColor: WidgetStateProperty.all(kBlack),
                      elevation: WidgetStateProperty.all(0),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 14),
                      ),
                      textStyle: WidgetStateProperty.all(
                        kCaptionTextStyle(
                          context,
                        ).copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    onPressed: _pickLocation,
                    icon: const Icon(Iconsax.map, size: 18),
                    label: const Text('Pick Location From Map'),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: kPremiumButtonStyle(context),
                    icon: Icon(
                      isCreate ? Iconsax.add : Iconsax.save_2,
                      size: 18,
                    ),
                    label: Text(isCreate ? 'Create' : 'Save'),
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
