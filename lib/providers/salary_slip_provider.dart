import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/salary_slip_notifier.dart';

final salarySlipNotifierProvider = ChangeNotifierProvider<SalarySlipNotifier>((ref) => SalarySlipNotifier());
