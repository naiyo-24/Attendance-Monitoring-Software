

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/employee.dart';
import '../../providers/auth_provider.dart';
import '../../providers/current_location_provider.dart';

import '../../providers/employee_provider.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';


	class CurrentLocationMapScreen extends ConsumerStatefulWidget {
		const CurrentLocationMapScreen({super.key});

		@override
		ConsumerState<CurrentLocationMapScreen> createState() => _CurrentLocationMapScreenState();
	}


	class _CurrentLocationMapScreenState extends ConsumerState<CurrentLocationMapScreen> {
		int? selectedEmployeeId;

		@override
		void initState() {
			super.initState();
			WidgetsBinding.instance.addPostFrameCallback((_) {
				final auth = ref.read(authProvider);
				final adminId = auth.user?.adminId;
				if (adminId != null) {
					ref.read(employeeNotifierProvider).fetchEmployees(adminId);
				}
			});
		}

		@override
	Widget build(BuildContext context) {
		final auth = ref.watch(authProvider);
		final notifier = ref.watch(currentLocationNotifierProvider);
		final employeeNotifier = ref.watch(employeeNotifierProvider);
		final employees = employeeNotifier.employees;

		return Scaffold(
			drawer: auth.user != null ? SideNavBar(adminUser: auth.user!) : null,
			appBar: const PremiumAppBar(
				title: 'Current Locations',
				subtitle: 'Live employee locations',
			),
			body: Builder(
				builder: (context) {
					if (employeeNotifier.isLoading) {
						return const Center(child: CircularProgressIndicator());
					}
					if (employeeNotifier.error != null) {
						return Center(child: Text('Error: ${employeeNotifier.error}'));
					}

					return Column(
						children: [
							Padding(
								padding: const EdgeInsets.all(12.0),
								child: DropdownButtonFormField<int>(
									initialValue: selectedEmployeeId,
									decoration: const InputDecoration(
										labelText: 'Select Employee',
										border: OutlineInputBorder(),
									),
									items: employees.map((e) => DropdownMenuItem(
										value: e.employeeId,
										child: Text('${e.name} (${e.designation})'),
									)).toList(),
									onChanged: (value) async {
										setState(() => selectedEmployeeId = value);
										final adminId = auth.user?.adminId;
										if (adminId != null && value != null) {
											await ref.read(currentLocationNotifierProvider).fetchCurrentLocationForEmployee(adminId, value);
										}
									},
								),
							),
							Expanded(
								child: Builder(
									builder: (context) {
										if (notifier.isLoading) {
											return const Center(child: CircularProgressIndicator());
										}
										if (notifier.error != null) {
											return Center(child: Text('Error: ${notifier.error}'));
										}
										final markers = <Marker>[];
										if (selectedEmployeeId != null) {
											final employee = employees.firstWhere(
												(e) => e.employeeId == selectedEmployeeId,
												orElse: () => Employee(
													employeeId: 0,
													name: '-',
													phone: '-',
													email: '-',
													password: '-',
													bankName: '-',
													branchName: '-',
													accountNo: '-',
													ifsc: '-',
													designation: '-',
													address: '-',
												),
											);
											final locations = notifier.locations.where((loc) => loc.employeeId == selectedEmployeeId).toList();
											for (final location in locations) {
												if (location.coordinates.isNotEmpty) {
													final lastCoord = location.coordinates.last;
													markers.add(
														Marker(
															width: 160,
															height: 110,
															point: LatLng(lastCoord.lat, lastCoord.lng),
															child: Column(
																mainAxisSize: MainAxisSize.min,
																children: [
																	Container(
																		padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
																		margin: const EdgeInsets.only(bottom: 2),
																		decoration: BoxDecoration(
																			color: Colors.white,
																			borderRadius: BorderRadius.circular(8),
																			boxShadow: [
																				BoxShadow(
																					color: Colors.black.withAlpha(8),
																					blurRadius: 4,
																					offset: const Offset(0, 2),
																				),
																			],
																		),
																		child: Row(
																			mainAxisSize: MainAxisSize.min,
																			children: [
																				const Icon(Icons.person, color: Colors.blueGrey, size: 24),
																				const SizedBox(width: 6),
																				Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Text(
																							employee.name,
																							style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
																						),
																						Text(
																							employee.designation,
																							style: const TextStyle(fontSize: 12, color: Colors.black54),
																						),
																						Text(
																							employee.phone,
																							style: const TextStyle(fontSize: 12, color: Colors.black54),
																						),
																					],
																				),
																			],
																		),
																	),
																	const Icon(Icons.location_on, color: Colors.red, size: 36),
																],
															),
														),
													);
												}
											}
										}
										// Default to West Bengal if no markers
										const westBengalLatLng = LatLng(22.9786, 87.7478);
										return FlutterMap(
											options: MapOptions(
												initialCenter: markers.isNotEmpty ? markers.first.point : westBengalLatLng,
												initialZoom: 8.5,
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
							),
						],
					);
				},
			),
		);
		}
	}
