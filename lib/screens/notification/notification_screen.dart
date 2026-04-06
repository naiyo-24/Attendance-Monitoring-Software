import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'dart:ui';

import '../../providers/auth_provider.dart';
import '../../widgets/app_bar.dart';
import '../../cards/notification/notification_card.dart';
import '../../cards/notification/create_notification_card.dart';
import '../../notifiers/notification_notifier.dart';
import '../../models/notification.dart';
import '../../theme/app_theme.dart';
import '../../widgets/side_nav_bar.dart';
import '../../widgets/loader.dart';

final notificationNotifierProvider =
    ChangeNotifierProvider<NotificationNotifier>(
      (ref) => NotificationNotifier(),
    );

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  bool showCreateCard = false;
  int? _adminId;
  bool _initialized = false;

  Widget _glassSection({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: kWhite.withAlpha(190),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: kBlack.withAlpha((0.06 * 255).toInt()),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: kBlack.withAlpha((0.05 * 255).toInt()),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Padding(padding: const EdgeInsets.all(14), child: child),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final auth = ref.read(authProvider);
    final currentAdminId = auth.user?.adminId;
    if (currentAdminId != null) {
      _adminId = currentAdminId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _adminId == null) return;
        ref.read(notificationNotifierProvider).fetchNotifications(_adminId!);
      });
    }
    _initialized = true;
  }

  void _addNotification(String title, String? subtitle) async {
    final notifier = ref.read(notificationNotifierProvider);
    if (_adminId == null) return;
    await notifier.addNotification(
      NotificationModel(adminId: _adminId, title: title, subtitle: subtitle),
    );
    setState(() => showCreateCard = false);
  }

  void _deleteNotification(int idx) async {
    final notifier = ref.read(notificationNotifierProvider);
    if (_adminId == null) return;
    final notif = notifier.notifications[idx];
    if (notif.notificationId != null) {
      await notifier.deleteNotificationById(notif.notificationId!, _adminId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final notifier = ref.watch(notificationNotifierProvider);
    final adminUser = auth.user;
    final currentAdminId = adminUser?.adminId;
    if (currentAdminId != null && _adminId != currentAdminId) {
      _adminId = currentAdminId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _adminId == null) return;
        ref.read(notificationNotifierProvider).fetchNotifications(_adminId!);
      });
    }
    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'Notification Management',
        subtitle: 'Manage and send notifications',
      ),
      drawer: adminUser == null ? null : SideNavBar(adminUser: adminUser),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kWhite, kWhiteGrey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _glassSection(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Notifications',
                          style: kHeaderTextStyle(context).copyWith(
                            fontSize: Responsive.fontSize(context, 16),
                            color: kBrown,
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        icon: Icon(
                          showCreateCard ? Icons.close : Icons.add,
                          size: 20,
                        ),
                        label: Text(showCreateCard ? 'Close' : 'Create'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kBrown,
                          side: BorderSide(
                            color: kBrown.withAlpha((0.16 * 255).toInt()),
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
                        onPressed: () =>
                            setState(() => showCreateCard = !showCreateCard),
                      ),
                    ],
                  ),
                ),
                if (showCreateCard) ...[
                  const SizedBox(height: 14),
                  _glassSection(
                    child: CreateNotificationCard(
                      onCreate: _addNotification,
                      onCancel: () => setState(() => showCreateCard = false),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Expanded(
                  child: notifier.isLoading
                      ? const AttendX24Loader(text: 'Loading notifications…')
                      : notifier.error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Text(
                              notifier.error!,
                              textAlign: TextAlign.center,
                              style: kCaptionTextStyle(context).copyWith(
                                color: kerror,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        )
                      : notifier.notifications.isEmpty
                      ? Center(
                          child: _glassSection(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'No notifications found.',
                                textAlign: TextAlign.center,
                                style: kDescriptionTextStyle(context).copyWith(
                                  color: kBrown,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        )
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
        ),
      ),
    );
  }
}
