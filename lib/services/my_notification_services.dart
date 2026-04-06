import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification.dart';

typedef MyNotificationReceivedCallback = void Function(NotificationModel);

class MyNotificationService {
  MyNotificationService._();

  static final MyNotificationService instance = MyNotificationService._();

  static const String storageKey = 'my_notifications_v1';

  static const String androidChannelId = 'my_notifications_channel';
  static const String androidChannelName = 'My Notifications';
  static const String androidChannelDescription =
      'Incoming push notifications for AttendX24.';

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String _webVapidKey = String.fromEnvironment('FCM_VAPID_KEY');

  bool _localInitialized = false;
  bool _listenersAttached = false;

  Future<List<NotificationModel>> loadStored() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    if (raw == null || raw.trim().isEmpty) return <NotificationModel>[];

    final decoded = jsonDecode(raw);
    if (decoded is! List) return <NotificationModel>[];

    return decoded
        .whereType<Map>()
        .map((e) => NotificationModel.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<void> saveStored(List<NotificationModel> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(notifications.map((n) => n.toJson()).toList());
    await prefs.setString(storageKey, raw);
  }

  Future<void> startListening(MyNotificationReceivedCallback onReceive) async {
    if (_listenersAttached) return;

    await _initLocalNotifications();
    await _requestNotificationPermissions();

    _listenersAttached = true;

    // Ensures the browser/device is registered and we have a token.
    // On web, a VAPID key is required.
    try {
      final token = await _messaging.getToken(
        vapidKey: kIsWeb && _webVapidKey.trim().isNotEmpty
            ? _webVapidKey.trim()
            : null,
      );

      if (kDebugMode) {
        if (kIsWeb && _webVapidKey.trim().isEmpty) {
          debugPrint(
            'FCM web requires a VAPID key. Run: flutter run -d chrome --dart-define=FCM_VAPID_KEY=<YOUR_KEY>',
          );
        }
        debugPrint('FCM token: $token');
      }
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
    }

    FirebaseMessaging.onMessage.listen((message) async {
      if (kDebugMode) {
        debugPrint('FCM onMessage: ${message.messageId}');
      }
      final model = _mapRemoteMessage(message);
      onReceive(model);
      await _showLocalNotification(model);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) {
        debugPrint('FCM onMessageOpenedApp: ${message.messageId}');
      }
      final model = _mapRemoteMessage(message);
      onReceive(model);
    });

    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      if (kDebugMode) {
        debugPrint('FCM getInitialMessage: ${initial.messageId}');
      }
      final model = _mapRemoteMessage(initial);
      onReceive(model);
    }
  }

  NotificationModel _mapRemoteMessage(RemoteMessage message) {
    final title =
        (message.notification?.title ?? message.data['title']?.toString() ?? '')
            .trim();
    final body =
        (message.notification?.body ?? message.data['body']?.toString() ?? '')
            .trim();

    return NotificationModel(
      title: title.isEmpty ? 'Notification' : title,
      subtitle: body.isEmpty ? null : body,
    );
  }

  Future<void> _initLocalNotifications() async {
    if (_localInitialized) return;
    if (kIsWeb) {
      _localInitialized = true;
      return;
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwinInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );

    await _localNotifications.initialize(settings: initSettings);

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      const channel = AndroidNotificationChannel(
        androidChannelId,
        androidChannelName,
        description: androidChannelDescription,
        importance: Importance.high,
      );
      await androidPlugin.createNotificationChannel(channel);
    }

    _localInitialized = true;
  }

  Future<void> _requestNotificationPermissions() async {
    try {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
    } catch (_) {
      // Best effort.
    }

    if (kIsWeb) {
      return;
    }

    try {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (_) {
      // Best effort.
    }

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      try {
        await androidPlugin.requestNotificationsPermission();
      } catch (_) {
        // Best effort.
      }
    }

    final iosPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (iosPlugin != null) {
      try {
        await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      } catch (_) {
        // Best effort.
      }
    }

    final macosPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    if (macosPlugin != null) {
      try {
        await macosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      } catch (_) {
        // Best effort.
      }
    }
  }

  Future<void> _showLocalNotification(NotificationModel notification) async {
    if (kIsWeb) return;
    if (!_localInitialized) return;

    final androidDetails = AndroidNotificationDetails(
      androidChannelId,
      androidChannelName,
      channelDescription: androidChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const darwinDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    final id = DateTime.now().millisecondsSinceEpoch.remainder(1 << 31);

    await _localNotifications.show(
      id: id,
      title: notification.title,
      body: notification.subtitle,
      notificationDetails: details,
    );
  }
}
