import 'package:flutter/material.dart';
import '../../models/notification.dart';
import '../../theme/app_theme.dart';

class NotificationCard extends StatelessWidget {
	final NotificationModel notification;
	final VoidCallback? onDelete;
	const NotificationCard({super.key, required this.notification, this.onDelete});

	@override
	Widget build(BuildContext context) {
		return Card(
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
			color: kWhiteGrey,
			elevation: 1.5,
			margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
			child: ListTile(
				title: Text(notification.title, style: kHeaderTextStyle(context).copyWith(fontSize: 18)),
				subtitle: notification.subtitle != null && notification.subtitle!.isNotEmpty
						? Text(notification.subtitle!, style: kDescriptionTextStyle(context))
						: null,
				trailing: IconButton(
					icon: const Icon(Icons.delete, color: kerror),
					onPressed: onDelete,
					tooltip: 'Delete notification',
				),
				contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
				shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
			),
		);
	}
}
