import 'package:flutter/material.dart';
import '../notifiers/leaves_notifier.dart';

class LeavesProvider extends InheritedNotifier<LeavesNotifier> {
	const LeavesProvider({
		super.key,
		required LeavesNotifier super.notifier,
		required super.child,
	});

	static LeavesNotifier of(BuildContext context) {
		final LeavesProvider? provider = context.dependOnInheritedWidgetOfExactType<LeavesProvider>();
		assert(provider != null, 'No LeavesProvider found in context');
		return provider!.notifier!;
	}
}
