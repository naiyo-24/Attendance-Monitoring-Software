import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_bar.dart';
import '../../cards/notification/notification_card.dart';
import '../../cards/notification/create_notification_card.dart';
import '../../notifiers/notification_notifier.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification.dart';
import '../../theme/app_theme.dart';
import '../../widgets/side_nav_bar.dart';

class NotificationScreen extends ConsumerStatefulWidget {
	const NotificationScreen({super.key});

	@override
	ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
	late NotificationNotifier notificationNotifier;
	bool showCreateCard = false;
	int? adminId;

	@override
	void initState() {
		super.initState();
		notificationNotifier = NotificationNotifier();
	}

	void _addNotification(String title, String? subtitle) async {
		if (adminId == null) return;
		await notificationNotifier.addNotification(
			NotificationModel(adminId: adminId, title: title, subtitle: subtitle),
		);
		setState(() => showCreateCard = false);
	}

	void _deleteNotification(int idx) async {
		if (adminId == null) return;
		final notif = notificationNotifier.notifications[idx];
		if (notif.notificationId != null) {
			await notificationNotifier.deleteNotificationById(notif.notificationId!, adminId!);
		}
		setState(() {});
	}

	@override
	Widget build(BuildContext context) {
		final auth = ref.watch(authProvider);
		final currentAdminId = auth.user?.adminId;
		if (currentAdminId != null && (adminId != currentAdminId || notificationNotifier.notifications.isEmpty)) {
			adminId = currentAdminId;
			notificationNotifier.fetchNotifications(adminId!);
		}
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
								child: notificationNotifier.isLoading
										? const Center(child: CircularProgressIndicator())
										: notificationNotifier.notifications.isEmpty
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
							if (notificationNotifier.error != null)
								Padding(
									padding: const EdgeInsets.only(top: 12.0),
									child: Text(
										notificationNotifier.error!,
										style: TextStyle(color: kerror),
									),
								),
						],
					),
				),
			),
		);
	}
}
