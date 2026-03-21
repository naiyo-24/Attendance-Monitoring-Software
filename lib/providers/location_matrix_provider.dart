import 'package:flutter/material.dart';
import '../notifiers/location_matrix_notifier.dart';

class LocationMatrixProvider extends InheritedNotifier<LocationMatrixNotifier> {
  const LocationMatrixProvider({
    super.key,
    required LocationMatrixNotifier super.notifier,
    required super.child,
  });

  static LocationMatrixNotifier of(BuildContext context) {
    final LocationMatrixProvider? provider = context.dependOnInheritedWidgetOfExactType<LocationMatrixProvider>();
    assert(provider != null, 'No LocationMatrixProvider found in context');
    return provider!.notifier!;
  }
}
