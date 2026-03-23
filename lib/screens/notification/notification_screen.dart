import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/app_bar.dart';
import '../../cards/notification/notification_card.dart';
import '../../cards/notification/create_notification_card.dart';
import '../../notifiers/notification_notifier.dart';
import '../../models/notification.dart';
import '../../theme/app_theme.dart';
import '../../widgets/side_nav_bar.dart';


final notificationNotifierProvider = ChangeNotifierProvider<NotificationNotifier>((ref) => NotificationNotifier());

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  bool showCreateCard = false;
  int? adminId;

  void _addNotification(String title, String? subtitle) async {
    final notifier = ref.read(notificationNotifierProvider);
    if (adminId == null) return;
    await notifier.addNotification(
      NotificationModel(adminId: adminId, title: title, subtitle: subtitle),
    );
    setState(() => showCreateCard = false);
  }

  void _deleteNotification(int idx) async {
    final notifier = ref.read(notificationNotifierProvider);
    if (adminId == null) return;
    final notif = notifier.notifications[idx];
    if (notif.notificationId != null) {
      await notifier.deleteNotificationById(notif.notificationId!, adminId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final notifier = ref.watch(notificationNotifierProvider);
    final currentAdminId = auth.user?.adminId;
    if (currentAdminId != null && (adminId != currentAdminId || notifier.notifications.isEmpty)) {
      adminId = currentAdminId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(notificationNotifierProvider).fetchNotifications(adminId!);
      });
    }
    return Scaffold(
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
              child: notifier.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : notifier.notifications.isEmpty
                      ? Center(child: Text('No notifications found.', style: kDescriptionTextStyle(context)))
                      : ListView.builder(
                          itemCount: notifier.notifications.length,
                          itemBuilder: (context, idx) {
                            final notification = notifier.notifications[idx];
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
    );
  }
}
