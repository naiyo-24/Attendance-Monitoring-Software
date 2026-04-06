import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/notification.dart';
import '../services/my_notification_services.dart';

class MyNotificationNotifier extends ChangeNotifier {
  final MyNotificationService _service;
  final List<NotificationModel> _notifications = <NotificationModel>[];

  bool _initialized = false;
  bool _isLoading = false;
  String? _error;

  MyNotificationNotifier({MyNotificationService? service})
    : _service = service ?? MyNotificationService.instance;

  List<NotificationModel> get notifications =>
      List<NotificationModel>.unmodifiable(_notifications);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final stored = await _service.loadStored();
      _notifications
        ..clear()
        ..addAll(stored);
      _isLoading = false;
      notifyListeners();

      await _service.startListening(_onReceive);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onReceive(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();

    unawaited(_service.saveStored(_notifications));
  }
}
