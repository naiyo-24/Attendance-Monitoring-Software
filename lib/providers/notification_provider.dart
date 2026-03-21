import 'package:flutter/material.dart';
import '../notifiers/notification_notifier.dart';

class NotificationProvider extends InheritedNotifier<NotificationNotifier> {
	const NotificationProvider({
		super.key,
		required NotificationNotifier notifier,
		required Widget child,
	}) : super(notifier: notifier, child: child);

	static NotificationNotifier of(BuildContext context) {
		final NotificationProvider? provider = context.dependOnInheritedWidgetOfExactType<NotificationProvider>();
		assert(provider != null, 'No NotificationProvider found in context');
		return provider!.notifier!;
	}
}
