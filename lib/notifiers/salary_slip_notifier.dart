import 'package:flutter/material.dart';
import '../models/salary_slip.dart';

class SalarySlipNotifier extends ChangeNotifier {
	final List<SalarySlip> _salarySlips = [];

	List<SalarySlip> get salarySlips => List.unmodifiable(_salarySlips);

	void addSalarySlip(SalarySlip slip) {
		_salarySlips.add(slip);
		notifyListeners();
	}

	void updateSalarySlip(int index, SalarySlip slip) {
		if (index >= 0 && index < _salarySlips.length) {
			_salarySlips[index] = slip;
			notifyListeners();
		}
	}

	void deleteSalarySlip(int index) {
		if (index >= 0 && index < _salarySlips.length) {
			_salarySlips.removeAt(index);
			notifyListeners();
		}
	}

	void setSalarySlips(List<SalarySlip> slips) {
		_salarySlips.clear();
		_salarySlips.addAll(slips);
		notifyListeners();
	}
}
