import 'package:flutter/material.dart';
import '../notifiers/employee_notifier.dart';

class EmployeeProvider extends InheritedNotifier<EmployeeNotifier> {
  const EmployeeProvider({
    super.key,
    required EmployeeNotifier super.notifier,
    required super.child,
  });

  static EmployeeNotifier of(BuildContext context) {
    final EmployeeProvider? provider = context.dependOnInheritedWidgetOfExactType<EmployeeProvider>();
    assert(provider != null, 'No EmployeeProvider found in context');
    return provider!.notifier!;
  }
}
