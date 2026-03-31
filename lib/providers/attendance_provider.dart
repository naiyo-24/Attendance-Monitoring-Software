import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/attendance_notifier.dart';

class AttendanceProvider extends StatelessWidget {
	final Widget child;
	const AttendanceProvider({required this.child, super.key});

	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider(
			create: (_) => AttendanceNotifier(),
			child: child,
		);
	}
}
