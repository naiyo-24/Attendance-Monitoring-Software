
import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/current_location_notifier.dart';

final currentLocationNotifierProvider = ChangeNotifierProvider<CurrentLocationNotifier>((ref) {
	return CurrentLocationNotifier();
});
