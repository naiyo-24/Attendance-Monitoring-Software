

import 'package:flutter/material.dart';
import '../models/current_location.dart';
import '../services/current_location_services.dart';

class CurrentLocationNotifier extends ChangeNotifier {
	final CurrentLocationService _service = CurrentLocationService();
	List<CurrentLocation> _locations = [];
	bool _isLoading = false;
	String? _error;

	List<CurrentLocation> get locations => _locations;
	bool get isLoading => _isLoading;
	String? get error => _error;

		Future<void> fetchCurrentLocationForEmployee(int adminId, int employeeId) async {
		_isLoading = true;
		_error = null;
		notifyListeners();
		try {
			_locations = await _service.fetchCurrentLocationForEmployee(adminId, employeeId);
		} catch (e) {
			_error = e.toString();
		}
		_isLoading = false;
		notifyListeners();
	}
}
