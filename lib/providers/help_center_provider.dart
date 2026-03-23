import 'package:flutter/material.dart';
import '../notifiers/help_center_notifier.dart';

class HelpCenterProvider extends InheritedNotifier<HelpCenterNotifier> {
	const HelpCenterProvider({
		super.key,
		required super.child,
		required HelpCenterNotifier notifier,
	}) : super(notifier: notifier);

	static HelpCenterNotifier of(BuildContext context) {
		final HelpCenterProvider? provider = context.dependOnInheritedWidgetOfExactType<HelpCenterProvider>();
		assert(provider != null, 'No HelpCenterProvider found in context');
		return provider!.notifier!;
	}
}
