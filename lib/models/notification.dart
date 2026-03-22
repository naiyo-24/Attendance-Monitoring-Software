class NotificationModel {
	final int? notificationId;
	final int? adminId;
	final String title;
	final String? subtitle;

	NotificationModel({
		this.notificationId,
		this.adminId,
		required this.title,
		this.subtitle,
	});

	factory NotificationModel.fromJson(Map<String, dynamic> json) {
		return NotificationModel(
			notificationId: json['notification_id'],
			adminId: json['admin_id'],
			title: json['title'] ?? '',
			subtitle: json['subtitle'],
		);
	}

	Map<String, dynamic> toJson() {
		return {
			if (notificationId != null) 'notification_id': notificationId,
			if (adminId != null) 'admin_id': adminId,
			'title': title,
			'subtitle': subtitle,
		};
	}
}
