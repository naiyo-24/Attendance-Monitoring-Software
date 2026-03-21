import 'package:flutter/material.dart';
import '../models/help_center.dart';

class HelpCenterNotifier extends ChangeNotifier {
	HelpCenter? _helpCenter;

	HelpCenter? get helpCenter => _helpCenter;

	void setHelpCenter(HelpCenter helpCenter) {
		_helpCenter = helpCenter;
		notifyListeners();
	}
}
