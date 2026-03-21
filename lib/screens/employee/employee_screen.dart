
import 'package:flutter/material.dart';

import '../../cards/employee/add_edit_employee_card.dart';
import '../../cards/employee/employee_card.dart';
import '../../notifiers/employee_notifier.dart';
import '../../providers/employee_provider.dart';
import '../../models/employee.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  String searchQuery = '';

  void _openAddEditEmployee({int? index, Employee? employee}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddEditEmployeeCard(
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
                  'profilePhoto': employee.profilePhoto,
                }
              : null,
          onSave: (empMap) {
            final notifier = EmployeeProvider.of(context);
            final emp = Employee(
              name: empMap['name'],
              phone: empMap['phone'],
              email: empMap['email'],
              password: empMap['password'],
              bankName: empMap['bankName'],
              branchName: empMap['branchName'],
              accountNo: empMap['accountNo'],
              ifsc: empMap['ifsc'],
              designation: empMap['designation'],
              profilePhoto: empMap['profilePhoto'],
            );
            if (index != null) {
              notifier.updateEmployee(index, emp);
            } else {
              notifier.addEmployee(emp);
            }
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _deleteEmployee(int index) {
    final notifier = EmployeeProvider.of(context);
    notifier.deleteEmployee(index);
  }

  @override
  Widget build(BuildContext context) {
    return EmployeeProvider(
      notifier: EmployeeNotifier(),
      child: Builder(
        builder: (context) {
          final notifier = EmployeeProvider.of(context);
          final employees = notifier.employees;
          final filteredEmployees = employees.where((emp) {
            final name = emp.name.toLowerCase();
            final phone = emp.phone;
            return name.contains(searchQuery.toLowerCase()) || phone.contains(searchQuery);
          }).toList();

          return Scaffold(
            drawer: const SideNavBar(),
            appBar: const PremiumAppBar(
              title: 'Employees',
              subtitle: 'Manage & onboard employees',
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: kPremiumButtonStyle(context).copyWith(
                        backgroundColor: WidgetStateProperty.all(kGreen),
                        foregroundColor: WidgetStateProperty.all(kWhite),
                        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 18)),
                        textStyle: WidgetStateProperty.all(
                          kHeaderTextStyle(context).copyWith(fontSize: 18),
                        ),
                      ),
                      icon: const Icon(Icons.person_add_alt_1_rounded, size: 26),
                      label: const Text('Onboard a New Employee'),
                      onPressed: () => _openAddEditEmployee(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: kBrown),
                      hintText: 'Search by name or phone no.',
                      hintStyle: kTaglineTextStyle(context).copyWith(color: kBrown.withOpacity(0.7)),
                      filled: true,
                      fillColor: kWhiteGrey,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: const BorderSide(color: kGreen, width: 2),
                      ),
                    ),
                    style: kDescriptionTextStyle(context).copyWith(fontSize: 16),
                    onChanged: (val) => setState(() => searchQuery = val),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.separated(
                      itemCount: filteredEmployees.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
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
                          'profilePhoto': filteredEmployees[index].profilePhoto,
                        },
                        onEdit: () => _openAddEditEmployee(
                          index: employees.indexOf(filteredEmployees[index]),
                          employee: filteredEmployees[index],
                        ),
                        onDelete: () => _deleteEmployee(employees.indexOf(filteredEmployees[index])),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
