

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/current_location_provider.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';


	class CurrentLocationMapScreen extends ConsumerStatefulWidget {
		const CurrentLocationMapScreen({super.key});

		@override
		ConsumerState<CurrentLocationMapScreen> createState() => _CurrentLocationMapScreenState();
	}

	class _CurrentLocationMapScreenState extends ConsumerState<CurrentLocationMapScreen> {
		@override
		void initState() {
			super.initState();
			WidgetsBinding.instance.addPostFrameCallback((_) {
				final auth = ref.read(authProvider);
				final notifier = ref.read(currentLocationNotifierProvider);
				final adminId = auth.user?.adminId;
				if (adminId != null) {
					notifier.fetchCurrentLocations(adminId);
				}
			});
		}

		@override
		Widget build(BuildContext context) {
			final auth = ref.watch(authProvider);
			final notifier = ref.watch(currentLocationNotifierProvider);
			return Scaffold(
				drawer: auth.user != null ? SideNavBar(adminUser: auth.user!) : null,
				appBar: const PremiumAppBar(
					title: 'Current Locations',
					subtitle: 'Live employee locations',
				),
				body: Builder(
					builder: (context) {
						if (notifier.isLoading) {
							return const Center(child: CircularProgressIndicator());
						}
						if (notifier.error != null) {
							return Center(child: Text('Error: ${notifier.error}'));
						}
						final markers = <Marker>[];
						for (final location in notifier.locations) {
							if (location.coordinates.isNotEmpty) {
								final lastCoord = location.coordinates.last;
								markers.add(
									Marker(
										width: 40,
										height: 40,
										point: LatLng(lastCoord.lat, lastCoord.lng),
										child: const Icon(Icons.location_on, color: Colors.red, size: 36),
									),
								);
							}
						}
						return FlutterMap(
							options: MapOptions(
								initialCenter: markers.isNotEmpty ? markers.first.point : const LatLng(22.5667, 88.3667),
								initialZoom: 12,
							),
							children: [
								TileLayer(
									urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
									subdomains: const ['a', 'b', 'c'],
									userAgentPackageName: 'com.example.attendance',
								),
								MarkerLayer(markers: markers),
							],
						);
					},
				),
			);
		}
	}
