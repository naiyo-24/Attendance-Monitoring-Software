import 'package:flutter_riverpod/legacy.dart';

import '../notifiers/my_notification_notifier.dart';

final myNotificationNotifierProvider =
    ChangeNotifierProvider<MyNotificationNotifier>((ref) {
      return MyNotificationNotifier();
    });
