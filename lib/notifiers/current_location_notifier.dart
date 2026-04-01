
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

	Future<void> fetchCurrentLocations(int adminId) async {
		_isLoading = true;
		_error = null;
		notifyListeners();
		try {
			_locations = await _service.fetchCurrentLocationsByAdmin(adminId);
		} catch (e) {
			_error = e.toString();
		}
		_isLoading = false;
		notifyListeners();
	}
}
