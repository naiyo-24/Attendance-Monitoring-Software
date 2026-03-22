import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/notification.dart';
import 'api_url.dart';

class NotificationService {
	final Dio _dio = Dio(
		BaseOptions(
			baseUrl: baseUrl,
			connectTimeout: const Duration(seconds: 10),
			receiveTimeout: const Duration(seconds: 10),
			headers: {'Content-Type': 'application/json'},
		),
	)..interceptors.add(PrettyDioLogger());

	Future<NotificationModel> createNotification(NotificationModel notification) async {
		final response = await _dio.post(
			createNotificationEndpoint,
			data: notification.toJson(),
		);
		if (response.statusCode == 200 || response.statusCode == 201) {
			return NotificationModel.fromJson({
				...notification.toJson(),
				'notification_id': response.data['notification_id'],
			});
		} else {
			throw Exception('Failed to create notification');
		}
	}

	Future<List<NotificationModel>> getNotificationsByAdmin(int adminId) async {
		final response = await _dio.get(getNotificationsByAdminEndpoint(adminId));
		if (response.statusCode == 200) {
			final data = response.data as List;
			return data.map((json) => NotificationModel.fromJson(json)).toList();
		} else {
			throw Exception('Failed to fetch notifications');
		}
	}

	Future<void> deleteNotification(int notificationId, int adminId) async {
		final response = await _dio.delete(deleteNotificationEndpoint(notificationId, adminId));
		if (response.statusCode != 200) {
			throw Exception('Failed to delete notification');
		}
	}
}
