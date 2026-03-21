import 'package:flutter/material.dart';
import '../notifiers/salary_slip_notifier.dart';

class SalarySlipProvider extends InheritedNotifier<SalarySlipNotifier> {
	const SalarySlipProvider({
		super.key,
		required SalarySlipNotifier notifier,
		required Widget child,
	}) : super(notifier: notifier, child: child);

	static SalarySlipNotifier of(BuildContext context) {
		final SalarySlipProvider? provider = context.dependOnInheritedWidgetOfExactType<SalarySlipProvider>();
		assert(provider != null, 'No SalarySlipProvider found in context');
		return provider!.notifier!;
	}
}
