import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CreateNotificationCard extends StatefulWidget {
	final void Function(String title, String? subtitle) onCreate;
	final VoidCallback? onCancel;
	const CreateNotificationCard({super.key, required this.onCreate, this.onCancel});

	@override
	State<CreateNotificationCard> createState() => _CreateNotificationCardState();
}

class _CreateNotificationCardState extends State<CreateNotificationCard> {
	final TextEditingController _titleController = TextEditingController();
	final TextEditingController _subtitleController = TextEditingController();

	@override
	Widget build(BuildContext context) {
		return Card(
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
			color: kWhite,
			elevation: 2,
			margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
			child: Padding(
				padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text('Create New Notification', style: kHeaderTextStyle(context)),
						const SizedBox(height: 14),
						TextField(
							controller: _titleController,
							decoration: InputDecoration(
								labelText: 'Title',
								border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
								filled: true,
								fillColor: kWhiteGrey,
							),
						),
						const SizedBox(height: 12),
						TextField(
							controller: _subtitleController,
							decoration: InputDecoration(
								labelText: 'Subtitle',
								border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
								filled: true,
								fillColor: kWhiteGrey,
							),
						),
						const SizedBox(height: 18),
						Row(
							children: [
								ElevatedButton(
									onPressed: () {
										if (_titleController.text.isNotEmpty) {
											widget.onCreate(_titleController.text, _subtitleController.text.isNotEmpty ? _subtitleController.text : null);
										}
									},
									style: kPremiumButtonStyle(context),
									child: const Text('Save'),
								),
								const SizedBox(width: 10),
								OutlinedButton(
									onPressed: widget.onCancel,
									style: OutlinedButton.styleFrom(
										side: BorderSide(color: kBrown),
										shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
									),
									child: const Text('Cancel'),
								),
							],
						),
					],
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
