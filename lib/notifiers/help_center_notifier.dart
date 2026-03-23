import 'package:flutter/foundation.dart';
import '../models/help_center.dart';
import '../services/help_center_services.dart';

class HelpCenterNotifier extends ChangeNotifier {
	HelpCenter? _helpCenter;
	bool _isLoading = false;
	String? _error;
	final HelpCenterService _service = HelpCenterService();

	HelpCenter? get helpCenter => _helpCenter;
	bool get isLoading => _isLoading;
	String? get error => _error;

	Future<void> fetchHelpCenter() async {
		_isLoading = true;
		_error = null;
		notifyListeners();
		try {
			final centers = await _service.getAllHelpCenters();
			if (kDebugMode) {
			  print('Fetched help centers: $centers');
			}
			if (centers.isNotEmpty) {
				_helpCenter = centers.first;
				if (kDebugMode) {
				  print('Set help center: ${_helpCenter!.toJson()}');
				}
			}
			_isLoading = false;
			notifyListeners();
		} catch (e) {
			_error = e.toString();
			_isLoading = false;
			notifyListeners();
		}
	}

	void setHelpCenter(HelpCenter helpCenter) {
		_helpCenter = helpCenter;
		notifyListeners();
	}
}

