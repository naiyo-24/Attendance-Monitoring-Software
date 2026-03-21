import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CreateEditHolidayCard extends StatefulWidget {
  final DateTime? date;
  final String? occasion;
  final String? remarks;
  final void Function(DateTime date, String occasion, String remarks) onSave;
  const CreateEditHolidayCard({
    super.key,
    this.date,
    this.occasion,
    this.remarks,
    required this.onSave,
  });

  @override
  State<CreateEditHolidayCard> createState() => _CreateEditHolidayCardState();
}

class _CreateEditHolidayCardState extends State<CreateEditHolidayCard> {
  late TextEditingController _occasionController;
  late TextEditingController _remarksController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _occasionController = TextEditingController(text: widget.occasion ?? '');
    _remarksController = TextEditingController(text: widget.remarks ?? '');
    _selectedDate = widget.date;
  }

  @override
  void dispose() {
    _occasionController.dispose();
    _remarksController.dispose();
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
            widget.date == null ? 'Create New Holiday' : 'Edit Holiday',
            style: kHeaderTextStyle(context),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime(DateTime.now().year - 1),
                lastDate: DateTime(DateTime.now().year + 2),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              decoration: BoxDecoration(
                color: kWhiteGrey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kBrown.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: kBrown.withOpacity(0.7)),
                  const SizedBox(width: 12),
                  Text(
                    _selectedDate != null
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : 'Select Date',
                    style: kDescriptionTextStyle(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _occasionController,
            decoration: const InputDecoration(
              labelText: 'Occasion',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _remarksController,
            decoration: const InputDecoration(
              labelText: 'Remarks',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: kPremiumButtonStyle(context),
              onPressed: () {
                if (_selectedDate != null && _occasionController.text.isNotEmpty) {
                  widget.onSave(_selectedDate!, _occasionController.text, _remarksController.text);
                }
              },
              child: Text(widget.date == null ? 'Create' : 'Save'),
            ),
          ),
        ],
      ),
    );
  }
}
