import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../providers/my_notification_provider.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../widgets/loader.dart';
import '../../theme/app_theme.dart';
import '../../cards/my_notification/my_notification_card.dart';

class MyNotificationScreen extends ConsumerStatefulWidget {
  const MyNotificationScreen({super.key});

  @override
  ConsumerState<MyNotificationScreen> createState() =>
      _MyNotificationScreenState();
}

class _MyNotificationScreenState extends ConsumerState<MyNotificationScreen> {
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
    _initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(myNotificationNotifierProvider).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final adminUser = auth.user;
    final notifier = ref.watch(myNotificationNotifierProvider);

    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'My Notifications',
        subtitle: 'Stay updated with AttendX24',
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
                          'My Notifications',
                          style: kHeaderTextStyle(context).copyWith(
                            fontSize: Responsive.fontSize(context, 16),
                            color: kBrown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: notifier.isLoading
                      ? const AttendX24Loader(
                          text: 'Listening for notifications…',
                        )
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
                                'No notifications yet.',
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
                            return MyNotificationCard(
                              notification: notification,
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
