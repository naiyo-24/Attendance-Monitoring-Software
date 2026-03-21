import 'package:flutter/material.dart';
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
  late TextEditingController _latController;
  late TextEditingController _lngController;

  @override
  void initState() {
    super.initState();
    _latController = TextEditingController(text: widget.latitude ?? '');
    _lngController = TextEditingController(text: widget.longitude ?? '');
  }

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
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
            widget.latitude == null ? 'Create Location Matrix' : 'Edit Location Matrix',
            style: kHeaderTextStyle(context),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _latController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Latitude',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _lngController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Longitude',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: kPremiumButtonStyle(context),
              onPressed: () {
                widget.onSave(_latController.text, _lngController.text);
              },
              child: Text(widget.latitude == null ? 'Create' : 'Save'),
            ),
          ),
        ],
      ),
    );
  }
}
