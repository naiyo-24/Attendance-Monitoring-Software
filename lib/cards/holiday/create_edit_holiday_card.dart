import 'package:flutter/material.dart';
import 'dart:ui';
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
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: kWhite.withAlpha(230),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            border: Border.all(
              color: kBlack.withAlpha((0.06 * 255).toInt()),
              width: 1.2,
            ),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 22,
            bottom: MediaQuery.of(context).viewInsets.bottom + 22,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: kWhiteGrey.withAlpha(170),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: kBlack.withAlpha((0.06 * 255).toInt()),
                      ),
                    ),
                    child: Icon(Icons.event_available, color: kGreen, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.date == null
                          ? 'Create New Holiday'
                          : 'Edit Holiday',
                      style: kHeaderTextStyle(context).copyWith(fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text('Date', style: kCaptionTextStyle(context)),
              const SizedBox(height: 6),
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 18,
                  ),
                  decoration: BoxDecoration(
                    color: kWhiteGrey.withAlpha(170),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: kBlack.withAlpha((0.06 * 255).toInt()),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: kBrown.withAlpha((0.82 * 255).toInt()),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedDate != null
                              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                              : 'Select Date',
                          style: kCaptionTextStyle(context).copyWith(
                            color: kBrown,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: kBrown.withAlpha((0.62 * 255).toInt()),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Title', style: kCaptionTextStyle(context)),
              const SizedBox(height: 6),
              TextField(
                controller: _occasionController,
                style: kCaptionTextStyle(
                  context,
                ).copyWith(fontWeight: FontWeight.w900, color: kBrown),
                decoration: InputDecoration(
                  hintText: 'Holiday title',
                  filled: true,
                  fillColor: kWhiteGrey.withAlpha(170),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Remarks', style: kCaptionTextStyle(context)),
              const SizedBox(height: 6),
              TextField(
                controller: _remarksController,
                maxLines: 3,
                style: kCaptionTextStyle(
                  context,
                ).copyWith(fontWeight: FontWeight.w800, color: kBrown),
                decoration: InputDecoration(
                  hintText: 'Optional notes',
                  filled: true,
                  fillColor: kWhiteGrey.withAlpha(170),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: kPremiumButtonStyle(context),
                  onPressed: () {
                    if (_selectedDate != null &&
                        _occasionController.text.isNotEmpty) {
                      widget.onSave(
                        _selectedDate!,
                        _occasionController.text,
                        _remarksController.text,
                      );
                    }
                  },
                  child: Text(widget.date == null ? 'Create' : 'Save'),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}
