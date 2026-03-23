import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/employee_notifier.dart';

final employeeNotifierProvider = ChangeNotifierProvider<EmployeeNotifier>((ref) => EmployeeNotifier());
