import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'dart:ui';

class CreateNotificationCard extends StatefulWidget {
  final void Function(String title, String? subtitle) onCreate;
  final VoidCallback? onCancel;
  const CreateNotificationCard({
    super.key,
    required this.onCreate,
    this.onCancel,
  });

  @override
  State<CreateNotificationCard> createState() => _CreateNotificationCardState();
}

class _CreateNotificationCardState extends State<CreateNotificationCard> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: kWhite.withAlpha(210),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: kBlack.withAlpha((0.06 * 255).toInt()),
              width: 1.2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Column(
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
                      child: Icon(
                        Icons.notifications_active,
                        color: kGreen,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Create New Notification',
                        style: kHeaderTextStyle(
                          context,
                        ).copyWith(fontSize: 18, color: kBrown),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text('Title', style: kCaptionTextStyle(context)),
                const SizedBox(height: 6),
                TextField(
                  controller: _titleController,
                  style: kCaptionTextStyle(
                    context,
                  ).copyWith(fontWeight: FontWeight.w900, color: kBrown),
                  decoration: InputDecoration(
                    hintText: 'Notification title',
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
                const SizedBox(height: 12),
                Text('Subtitle', style: kCaptionTextStyle(context)),
                const SizedBox(height: 6),
                TextField(
                  controller: _subtitleController,
                  style: kCaptionTextStyle(
                    context,
                  ).copyWith(fontWeight: FontWeight.w800, color: kBrown),
                  decoration: InputDecoration(
                    hintText: 'Optional subtitle',
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
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_titleController.text.trim().isNotEmpty) {
                          widget.onCreate(
                            _titleController.text.trim(),
                            _subtitleController.text.trim().isNotEmpty
                                ? _subtitleController.text.trim()
                                : null,
                          );
                        }
                      },
                      style: kPremiumButtonStyle(context),
                      child: const Text('Save'),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: widget.onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kBrown,
                        side: BorderSide(
                          color: kBrown.withAlpha((0.18 * 255).toInt()),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        textStyle: kCaptionTextStyle(
                          context,
                        ).copyWith(fontWeight: FontWeight.w900),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }
}
