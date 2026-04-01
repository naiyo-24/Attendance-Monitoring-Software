
import 'package:provider/provider.dart';
import '../notifiers/current_location_notifier.dart';

final currentLocationProvider = ChangeNotifierProvider(
	create: (_) => CurrentLocationNotifier(),
);
