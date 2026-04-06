import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../models/current_location.dart';
import '../../models/employee.dart';
import '../../providers/auth_provider.dart';
import '../../providers/current_location_provider.dart';
import '../../providers/employee_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/loader.dart';
import '../../widgets/side_nav_bar.dart';

class CurrentLocationMapScreen extends ConsumerStatefulWidget {
  const CurrentLocationMapScreen({super.key});

  @override
  ConsumerState<CurrentLocationMapScreen> createState() =>
      _CurrentLocationMapScreenState();
}

class _CurrentLocationMapScreenState
    extends ConsumerState<CurrentLocationMapScreen> {
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

  Employee? _findEmployee(List<Employee> employees, int? employeeId) {
    if (employeeId == null) return null;
    for (final employee in employees) {
      if (employee.employeeId == employeeId) return employee;
    }
    return null;
  }

  Widget _glassSection({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: kWhite.withAlpha(190),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: kBlack.withAlpha((0.06 * 255).toInt()),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: kBlack.withAlpha((0.06 * 255).toInt()),
                blurRadius: 26,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Padding(padding: const EdgeInsets.all(14), child: child),
        ),
      ),
    );
  }

  Widget _errorCard(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: kerror.withAlpha((0.08 * 255).toInt()),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kerror.withAlpha((0.18 * 255).toInt())),
      ),
      child: Text(
        message,
        style: kCaptionTextStyle(
          context,
        ).copyWith(color: kerror, fontWeight: FontWeight.w700),
      ),
    );
  }

  List<Marker> _buildMarkers({
    required BuildContext context,
    required List<Employee> employees,
    required int? selectedEmployeeId,
    required List<CurrentLocation> locations,
  }) {
    final markers = <Marker>[];
    if (selectedEmployeeId == null) return markers;

    final employee =
        _findEmployee(employees, selectedEmployeeId) ??
        Employee(
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
        );

    final employeeLocations = locations
        .where((loc) => loc.employeeId == selectedEmployeeId)
        .toList();

    for (final location in employeeLocations) {
      if (location.coordinates.isNotEmpty) {
        final lastCoord = location.coordinates.last;
        markers.add(
          Marker(
            width: 190,
            height: 128,
            point: LatLng(lastCoord.lat, lastCoord.lng),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  margin: const EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                    color: kWhite.withAlpha(235),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: kBlack.withAlpha((0.06 * 255).toInt()),
                      width: 1.1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: kBlack.withAlpha((0.08 * 255).toInt()),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: kWhiteGrey.withAlpha(170),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: kBlack.withAlpha((0.06 * 255).toInt()),
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          color: kBrown.withAlpha((0.85 * 255).toInt()),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employee.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kCaptionTextStyle(context).copyWith(
                                fontWeight: FontWeight.w900,
                                color: kBrown,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              employee.designation,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kCaptionTextStyle(context).copyWith(
                                color: kBrown.withAlpha((0.72 * 255).toInt()),
                                fontWeight: FontWeight.w700,
                                fontSize: Responsive.fontSize(context, 12),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              employee.phone,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kCaptionTextStyle(context).copyWith(
                                color: kBrown.withAlpha((0.72 * 255).toInt()),
                                fontWeight: FontWeight.w700,
                                fontSize: Responsive.fontSize(context, 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.location_on,
                  color: kGreen,
                  size: 40,
                  shadows: [
                    Shadow(
                      color: kBlack.withAlpha((0.12 * 255).toInt()),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final employeeNotifier = ref.watch(employeeNotifierProvider);
    final locationNotifier = ref.watch(currentLocationNotifierProvider);

    final employees = employeeNotifier.employees;
    final selectedEmployee = _findEmployee(employees, selectedEmployeeId);

    return Scaffold(
      drawer: auth.user != null ? SideNavBar(adminUser: auth.user!) : null,
      appBar: const PremiumAppBar(
        title: 'Current Locations',
        subtitle: 'Live employee locations',
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kWhite, kWhiteGrey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            child: employeeNotifier.isLoading && employees.isEmpty
                ? const AttendX24Loader(text: 'Loading employees…')
                : Column(
                    children: [
                      _glassSection(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select employee',
                              style: kHeaderTextStyle(context).copyWith(
                                fontSize: Responsive.fontSize(context, 16),
                                color: kBrown,
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<int>(
                              initialValue: selectedEmployeeId,
                              isExpanded: true,
                              hint: Text(
                                employees.isEmpty
                                    ? 'No employees available'
                                    : 'Choose an employee',
                                style: kCaptionTextStyle(context).copyWith(
                                  color: kBrown.withAlpha((0.72 * 255).toInt()),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: kWhiteGrey.withAlpha(170),
                                prefixIcon: Icon(
                                  Icons.badge_outlined,
                                  color: kBrown.withAlpha((0.82 * 255).toInt()),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              items: employees
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.employeeId,
                                      child: Text(
                                        '${e.name} (${e.designation})',
                                        overflow: TextOverflow.ellipsis,
                                        style: kCaptionTextStyle(context)
                                            .copyWith(
                                              fontWeight: FontWeight.w800,
                                              color: kBrown,
                                            ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: employees.isEmpty
                                  ? null
                                  : (value) async {
                                      setState(
                                        () => selectedEmployeeId = value,
                                      );
                                      final adminId = auth.user?.adminId;
                                      if (adminId != null && value != null) {
                                        await ref
                                            .read(
                                              currentLocationNotifierProvider,
                                            )
                                            .fetchCurrentLocationForEmployee(
                                              adminId,
                                              value,
                                            );
                                      }
                                    },
                            ),
                            if (employeeNotifier.error != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: _errorCard(
                                  context,
                                  employeeNotifier.error!.replaceFirst(
                                    'Exception: ',
                                    '',
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: _glassSection(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: kWhiteGrey.withAlpha(170),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: kBlack.withAlpha(
                                          (0.06 * 255).toInt(),
                                        ),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.map_outlined,
                                      color: kGreen,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          selectedEmployee == null
                                              ? 'Live map'
                                              : selectedEmployee.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: kHeaderTextStyle(context)
                                              .copyWith(
                                                fontSize: Responsive.fontSize(
                                                  context,
                                                  16,
                                                ),
                                                color: kBrown,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          selectedEmployee == null
                                              ? 'Select an employee to view their latest location'
                                              : selectedEmployee.designation,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: kCaptionTextStyle(context)
                                              .copyWith(
                                                color: kBrown.withAlpha(
                                                  (0.72 * 255).toInt(),
                                                ),
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: kWhite,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: kBlack.withAlpha(
                                          (0.06 * 255).toInt(),
                                        ),
                                      ),
                                    ),
                                    child: Builder(
                                      builder: (context) {
                                        if (selectedEmployeeId == null) {
                                          return Center(
                                            child: Text(
                                              'Choose an employee above to start',
                                              textAlign: TextAlign.center,
                                              style: kCaptionTextStyle(context)
                                                  .copyWith(
                                                    fontWeight: FontWeight.w800,
                                                    color: kBrown.withAlpha(
                                                      (0.74 * 255).toInt(),
                                                    ),
                                                  ),
                                            ),
                                          );
                                        }

                                        if (locationNotifier.isLoading) {
                                          return const AttendX24Loader(
                                            text: 'Fetching live location…',
                                            logoSize: 64,
                                          );
                                        }

                                        if (locationNotifier.error != null) {
                                          return Padding(
                                            padding: const EdgeInsets.all(14),
                                            child: _errorCard(
                                              context,
                                              locationNotifier.error!
                                                  .replaceFirst(
                                                    'Exception: ',
                                                    '',
                                                  ),
                                            ),
                                          );
                                        }

                                        final markers = _buildMarkers(
                                          context: context,
                                          employees: employees,
                                          selectedEmployeeId:
                                              selectedEmployeeId,
                                          locations: locationNotifier.locations,
                                        );

                                        if (markers.isEmpty) {
                                          return Center(
                                            child: Text(
                                              'No location points available yet',
                                              textAlign: TextAlign.center,
                                              style: kCaptionTextStyle(context)
                                                  .copyWith(
                                                    fontWeight: FontWeight.w800,
                                                    color: kBrown.withAlpha(
                                                      (0.74 * 255).toInt(),
                                                    ),
                                                  ),
                                            ),
                                          );
                                        }

                                        const westBengalLatLng = LatLng(
                                          22.9786,
                                          87.7478,
                                        );
                                        return FlutterMap(
                                          options: MapOptions(
                                            initialCenter: markers.isNotEmpty
                                                ? markers.first.point
                                                : westBengalLatLng,
                                            initialZoom: 9.0,
                                          ),
                                          children: [
                                            TileLayer(
                                              urlTemplate:
                                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                              subdomains: const ['a', 'b', 'c'],
                                              userAgentPackageName:
                                                  'com.example.attendance',
                                            ),
                                            MarkerLayer(markers: markers),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
