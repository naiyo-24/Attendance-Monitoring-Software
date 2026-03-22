import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/notification_services.dart';

class NotificationNotifier extends ChangeNotifier {
	final NotificationService _service = NotificationService();
	final List<NotificationModel> _notifications = [];
	bool _isLoading = false;
	String? _error;

	List<NotificationModel> get notifications => List.unmodifiable(_notifications);
	bool get isLoading => _isLoading;
	String? get error => _error;

	Future<void> fetchNotifications(int adminId) async {
		_isLoading = true;
		_error = null;
		notifyListeners();
		try {
			final notifs = await _service.getNotificationsByAdmin(adminId);
			_notifications.clear();
			_notifications.addAll(notifs);
			_isLoading = false;
			notifyListeners();
		} catch (e) {
			_error = e.toString();
			_isLoading = false;
			notifyListeners();
		}
	}

	Future<void> addNotification(NotificationModel notification) async {
		_isLoading = true;
		_error = null;
		notifyListeners();
		try {
			final notif = await _service.createNotification(notification);
			_notifications.insert(0, notif);
			_isLoading = false;
			notifyListeners();
		} catch (e) {
			_error = e.toString();
			_isLoading = false;
			notifyListeners();
		}
	}

	Future<void> deleteNotificationById(int notificationId, int adminId) async {
		_isLoading = true;
		_error = null;
		notifyListeners();
		try {
			await _service.deleteNotification(notificationId, adminId);
			_notifications.removeWhere((n) => n.notificationId == notificationId);
			_isLoading = false;
			notifyListeners();
		} catch (e) {
			_error = e.toString();
			_isLoading = false;
			notifyListeners();
		}
	}

	void setNotifications(List<NotificationModel> notifications) {
		_notifications.clear();
		_notifications.addAll(notifications);
		notifyListeners();
	}
}
