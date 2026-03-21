import 'package:flutter/material.dart';
import '../models/notification.dart';

class NotificationNotifier extends ChangeNotifier {
	final List<NotificationModel> _notifications = [];

	List<NotificationModel> get notifications => List.unmodifiable(_notifications);

	void addNotification(NotificationModel notification) {
		_notifications.add(notification);
		notifyListeners();
	}

	void deleteNotification(int index) {
		if (index >= 0 && index < _notifications.length) {
			_notifications.removeAt(index);
			notifyListeners();
		}
	}

	void setNotifications(List<NotificationModel> notifications) {
		_notifications.clear();
		_notifications.addAll(notifications);
		notifyListeners();
	}
}
