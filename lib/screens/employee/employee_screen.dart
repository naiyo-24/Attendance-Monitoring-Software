import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../cards/employee/add_edit_employee_card.dart';
import '../../cards/employee/employee_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/employee_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/employee.dart';
import '../../theme/app_theme.dart';
import '../../utils/employee_download_pdf.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/loader.dart';
import '../../widgets/side_nav_bar.dart';

class EmployeeScreen extends ConsumerStatefulWidget {
  const EmployeeScreen({super.key});

  @override
  ConsumerState<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends ConsumerState<EmployeeScreen> {
  String searchQuery = '';

  Future<void> _downloadEmployeeRecords(List<Employee> employees) async {
    await EmployeeDownloadPdf.downloadEmployeeRecords(
      context: context,
      employees: employees,
    );
  }

  void _openAddEditEmployee({Employee? employee}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => AddEditEmployeeCard(
        employee: employee != null
            ? {
                'name': employee.name,
                'phone': employee.phone,
                'email': employee.email,
                'password': employee.password,
                'bankName': employee.bankName,
                'branchName': employee.branchName,
                'accountNo': employee.accountNo,
                'ifsc': employee.ifsc,
                'designation': employee.designation,
                'address': employee.address,
                'profilePhoto': employee.profilePhoto,
              }
            : null,
        onSave: (empMap) async {
          final notifier = ref.read(employeeNotifierProvider);
          final auth = ref.read(authProvider);
          final adminId = auth.user?.adminId;
          if (adminId == null) return;

          final emp = Employee(
            employeeId: employee?.employeeId,
            name: empMap['name'],
            phone: empMap['phone'],
            email: empMap['email'],
            password: empMap['password'],
            bankName: empMap['bankName'],
            branchName: empMap['branchName'],
            accountNo: empMap['accountNo'],
            ifsc: empMap['ifsc'],
            designation: empMap['designation'],
            address: empMap['address'],
            profilePhoto: empMap['profilePhoto'],
          );

          if (employee?.employeeId != null) {
            await notifier.updateEmployee(adminId, employee!.employeeId!, emp);
          } else {
            await notifier.addEmployee(adminId, emp);
          }

          if (!context.mounted) return;
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _deleteEmployee(int employeeId) async {
    final notifier = ref.read(employeeNotifierProvider);
    final auth = ref.read(authProvider);
    final adminId = auth.user?.adminId;
    if (adminId == null) return;
    await notifier.deleteEmployee(adminId, employeeId);
  }

  bool _fetched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = ref.read(authProvider);
      final adminId = auth.user?.adminId;
      if (adminId != null && !_fetched) {
        ref.read(employeeNotifierProvider).fetchEmployees(adminId);
        _fetched = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(employeeNotifierProvider);
    final auth = ref.watch(authProvider);
    final _ = auth.user?.adminId;

    final employees = notifier.employees;
    final filteredEmployees = employees.where((emp) {
      final name = emp.name.toLowerCase();
      final phone = emp.phone;
      return name.contains(searchQuery.toLowerCase()) ||
          phone.contains(searchQuery);
    }).toList();

    return Scaffold(
      drawer: SideNavBar(adminUser: auth.user!),
      appBar: const PremiumAppBar(
        title: 'Employees',
        subtitle: 'Manage & onboard employees',
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
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kWhite.withAlpha(75),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: kWhiteGrey, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: kBlack.withAlpha((0.05 * 255).toInt()),
                              blurRadius: 28,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  style: kPremiumButtonStyle(context).copyWith(
                                    backgroundColor: WidgetStateProperty.all(
                                      kGreen,
                                    ),
                                    foregroundColor: WidgetStateProperty.all(
                                      kWhite,
                                    ),
                                    padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(vertical: 18),
                                    ),
                                    textStyle: WidgetStateProperty.all(
                                      kHeaderTextStyle(
                                        context,
                                      ).copyWith(fontSize: 18, color: kWhite),
                                    ),
                                    elevation: WidgetStateProperty.all(10),
                                    shadowColor: WidgetStateProperty.all(
                                      kBlack.withAlpha(40),
                                    ),
                                  ),
                                  icon: const Icon(Iconsax.user_add, size: 24),
                                  label: const Text('Onboard a New Employee'),
                                  onPressed: () => _openAddEditEmployee(),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Iconsax.search_normal,
                                          color: kBrown,
                                        ),
                                        hintText: 'Search by name or phone no.',
                                        hintStyle: kCaptionTextStyle(context)
                                            .copyWith(
                                              color: kBrown.withAlpha(
                                                (0.75 * 255).toInt(),
                                              ),
                                            ),
                                        filled: true,
                                        fillColor: kWhiteGrey.withAlpha(140),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 16,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            22,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            22,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            22,
                                          ),
                                          borderSide: BorderSide(
                                            color: kBlack.withAlpha(40),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      style: kDescriptionTextStyle(context)
                                          .copyWith(
                                            fontSize: 16,
                                            color: kBlack,
                                            fontWeight: FontWeight.w500,
                                          ),
                                      onChanged: (val) =>
                                          setState(() => searchQuery = val),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: employees.isEmpty
                                          ? null
                                          : () => _downloadEmployeeRecords(
                                              employees,
                                            ),
                                      borderRadius: BorderRadius.circular(22),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: kWhiteGrey.withAlpha(160),
                                          borderRadius: BorderRadius.circular(
                                            22,
                                          ),
                                          border: Border.all(
                                            color: kBlack.withAlpha(
                                              (0.06 * 255).toInt(),
                                            ),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: kBlack.withAlpha(
                                                (0.06 * 255).toInt(),
                                              ),
                                              blurRadius: 16,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Iconsax.document_download,
                                              size: 20,
                                              color: employees.isEmpty
                                                  ? kBrown.withAlpha(
                                                      (0.35 * 255).toInt(),
                                                    )
                                                  : kBlack,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Download',
                                              style: kCaptionTextStyle(context)
                                                  .copyWith(
                                                    color: employees.isEmpty
                                                        ? kBrown.withAlpha(
                                                            (0.35 * 255)
                                                                .toInt(),
                                                          )
                                                        : kBlack,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Showing ${filteredEmployees.length} of ${employees.length} employees',
                                  style: kCaptionTextStyle(context).copyWith(
                                    color: kBrown.withAlpha(
                                      (0.7 * 255).toInt(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 18)),
                if (notifier.isLoading)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: AttendX24Loader(),
                  )
                else if (notifier.error != null)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        notifier.error!,
                        style: kDescriptionTextStyle(
                          context,
                        ).copyWith(color: kerror),
                      ),
                    ),
                  )
                else if (filteredEmployees.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        employees.isEmpty
                            ? 'No employees found.'
                            : 'No matches found.',
                        style: kDescriptionTextStyle(
                          context,
                        ).copyWith(color: kBrown),
                      ),
                    ),
                  )
                else
                  SliverList.separated(
                    itemCount: filteredEmployees.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) => EmployeeCard(
                      employee: {
                        'name': filteredEmployees[index].name,
                        'phone': filteredEmployees[index].phone,
                        'email': filteredEmployees[index].email,
                        'password': filteredEmployees[index].password,
                        'bankName': filteredEmployees[index].bankName,
                        'branchName': filteredEmployees[index].branchName,
                        'accountNo': filteredEmployees[index].accountNo,
                        'ifsc': filteredEmployees[index].ifsc,
                        'designation': filteredEmployees[index].designation,
                        'address': filteredEmployees[index].address,
                        'profilePhoto': filteredEmployees[index].profilePhoto,
                      },
                      onEdit: () => _openAddEditEmployee(
                        employee: filteredEmployees[index],
                      ),
                      onDelete: () =>
                          _deleteEmployee(filteredEmployees[index].employeeId!),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
