import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/dashboard_notifier.dart';

final dashboardProvider = ChangeNotifierProvider<DashboardNotifier>((ref) => DashboardNotifier());
