import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../cards/notification/notification_card.dart';
import '../../cards/notification/create_notification_card.dart';
import '../../notifiers/notification_notifier.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification.dart';
import '../../theme/app_theme.dart';
import '../../widgets/side_nav_bar.dart';

class NotificationScreen extends StatefulWidget {
	const NotificationScreen({super.key});

	@override
	State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
	late NotificationNotifier notificationNotifier;
	bool showCreateCard = false;

	@override
	void initState() {
		super.initState();
		notificationNotifier = NotificationNotifier();
		// Demo data
		if (notificationNotifier.notifications.isEmpty) {
			notificationNotifier.setNotifications([
				NotificationModel(title: 'Welcome!', subtitle: 'This is your admin panel.'),
				NotificationModel(title: 'System Update', subtitle: 'The system will be down at 10pm.'),
			]);
		}
	}

	void _addNotification(String title, String subtitle) {
		notificationNotifier.addNotification(NotificationModel(title: title, subtitle: subtitle));
		setState(() => showCreateCard = false);
	}

	void _deleteNotification(int index) {
		notificationNotifier.deleteNotification(index);
		setState(() {});
	}

	@override
	Widget build(BuildContext context) {
		return NotificationProvider(
			notifier: notificationNotifier,
			child: Scaffold(
				appBar: const PremiumAppBar(
					title: 'Notification Management',
					subtitle: 'Manage and send notifications',
				),
        drawer: const SideNavBar(),
				body: Padding(
					padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							if (!showCreateCard)
								ElevatedButton.icon(
									onPressed: () => setState(() => showCreateCard = true),
									icon: const Icon(Icons.add, color: Colors.white),
									label: const Text('Create New Notification'),
									style: kPremiumButtonStyle(context),
								),
							if (showCreateCard)
								CreateNotificationCard(
									onCreate: _addNotification,
									onCancel: () => setState(() => showCreateCard = false),
								),
							const SizedBox(height: 16),
							Expanded(
								child: notificationNotifier.notifications.isEmpty
										? Center(child: Text('No notifications found.', style: kDescriptionTextStyle(context)))
										: ListView.builder(
												itemCount: notificationNotifier.notifications.length,
												itemBuilder: (context, idx) {
													final notification = notificationNotifier.notifications[idx];
													return NotificationCard(
														notification: notification,
														onDelete: () => _deleteNotification(idx),
													);
												},
											),
							),
						],
					),
				),
			),
		);
	}
}
