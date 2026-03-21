import 'package:flutter/material.dart';
import '../notifiers/holiday_notifier.dart';

class HolidayProvider extends InheritedNotifier<HolidayNotifier> {
  const HolidayProvider({
    super.key,
    required HolidayNotifier notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static HolidayNotifier of(BuildContext context) {
    final HolidayProvider? provider = context.dependOnInheritedWidgetOfExactType<HolidayProvider>();
    assert(provider != null, 'No HolidayProvider found in context');
    return provider!.notifier!;
  }
}
