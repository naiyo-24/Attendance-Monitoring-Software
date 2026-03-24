
import 'dart:io';

import 'package:flutter/material.dart';
import '../models/salary_slip.dart';
import '../models/employee.dart';
import '../services/salary_slip_services.dart';

class SalarySlipNotifier extends ChangeNotifier {
	final SalarySlipService _service = SalarySlipService();
	final List<SalarySlip> _salarySlips = [];
	bool _isLoading = false;
	String? _error;

	List<SalarySlip> get salarySlips => List.unmodifiable(_salarySlips);
	bool get isLoading => _isLoading;
	String? get error => _error;

	Future<void> fetchSalarySlips({required int adminId, required Employee employee}) async {
		_isLoading = true;
		_error = null;
		notifyListeners();
		try {
			final slips = await _service.getSalarySlipsForEmployee(adminId: adminId, employee: employee);
			_salarySlips.clear();
			_salarySlips.addAll(slips);
			_isLoading = false;
			notifyListeners();
		} catch (e) {
			_error = e.toString();
			_isLoading = false;
			notifyListeners();
		}
	}

	Future<void> uploadOrUpdateSalarySlip({
		required int adminId,
		required Employee employee,
		required File pdfFile,
		int? slipId,
	}) async {
		_isLoading = true;
		_error = null;
		notifyListeners();
		try {
			SalarySlip slip;
			if (slipId == null) {
				slip = await _service.uploadSalarySlip(adminId: adminId, employee: employee, pdfFile: pdfFile);
				_salarySlips.add(slip);
			} else {
				slip = await _service.updateSalarySlip(adminId: adminId, employee: employee, slipId: slipId, pdfFile: pdfFile);
				final idx = _salarySlips.indexWhere((s) => s.slipId == slipId);
				if (idx != -1) _salarySlips[idx] = slip;
			}
			_isLoading = false;
			notifyListeners();
		} catch (e) {
			_error = e.toString();
			_isLoading = false;
			notifyListeners();
		}
	}

	Future<void> deleteSalarySlip({required int slipId}) async {
		_isLoading = true;
		_error = null;
		notifyListeners();
		try {
			await _service.deleteSalarySlip(slipId: slipId);
			_salarySlips.removeWhere((s) => s.slipId == slipId);
			_isLoading = false;
			notifyListeners();
		} catch (e) {
			_error = e.toString();
			_isLoading = false;
			notifyListeners();
		}
	}

	void setSalarySlips(List<SalarySlip> slips) {
		_salarySlips.clear();
		_salarySlips.addAll(slips);
		notifyListeners();
	}
}
