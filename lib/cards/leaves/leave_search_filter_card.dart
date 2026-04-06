import 'package:flutter/material.dart';
import '../../models/employee.dart';
import '../../models/leaves.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/employee_provider.dart';
import '../../theme/app_theme.dart';
import 'dart:ui';

class LeaveSearchFilterCard extends ConsumerStatefulWidget {
  final Future<void> Function(
    String search,
    DateTime? date,
    Employee? employee,
    LeaveStatus? status,
  )
  onFilter;
  const LeaveSearchFilterCard({super.key, required this.onFilter});

  @override
  ConsumerState<LeaveSearchFilterCard> createState() =>
      _LeaveSearchFilterCardState();
}

class _LeaveSearchFilterCardState extends ConsumerState<LeaveSearchFilterCard> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;
  Employee? _selectedEmployee;
  LeaveStatus? _selectedStatus;

  Widget _glassField({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: kWhite.withAlpha(210),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: kBlack.withAlpha((0.06 * 255).toInt()),
              width: 1.1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use EmployeeNotifier from Riverpod
    final employeeNotifier = ref.watch(employeeNotifierProvider);
    final employees = employeeNotifier.employees;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _glassField(
                child: TextField(
                  controller: _searchController,
                  style: kCaptionTextStyle(
                    context,
                  ).copyWith(fontWeight: FontWeight.w900, color: kBrown),
                  decoration: InputDecoration(
                    hintText: 'Search by reason or phone…',
                    hintStyle: kCaptionTextStyle(
                      context,
                    ).copyWith(color: kBrown.withAlpha((0.55 * 255).toInt())),
                    prefixIcon: Icon(
                      Icons.search,
                      color: kBrown.withAlpha((0.9 * 255).toInt()),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                  ),
                  onChanged: (_) => _onFilter(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today, size: 18),
              label: const Text('Date'),
              style: OutlinedButton.styleFrom(
                foregroundColor: kGreen,
                side: BorderSide(color: kGreen.withAlpha((0.22 * 255).toInt())),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                textStyle: kCaptionTextStyle(
                  context,
                ).copyWith(fontWeight: FontWeight.w900),
              ),
              onPressed: _showDatePicker,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _glassField(
                child: DropdownButtonFormField<Employee>(
                  initialValue:
                      _selectedEmployee != null &&
                          employees.contains(_selectedEmployee)
                      ? _selectedEmployee
                      : null,
                  items: [
                    const DropdownMenuItem<Employee>(
                      value: null,
                      child: Text('All Employees'),
                    ),
                    ...employees.map(
                      (e) => DropdownMenuItem<Employee>(
                        value: e,
                        child: Text(e.name),
                      ),
                    ),
                  ],
                  onChanged: (emp) {
                    setState(() => _selectedEmployee = emp);
                    _onFilter();
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                  ),
                  style: kCaptionTextStyle(
                    context,
                  ).copyWith(fontWeight: FontWeight.w900, color: kBrown),
                  iconEnabledColor: kBrown,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _glassField(
                child: DropdownButtonFormField<LeaveStatus?>(
                  initialValue: _selectedStatus,
                  items: const [
                    DropdownMenuItem<LeaveStatus?>(
                      value: null,
                      child: Text('All Status'),
                    ),
                    DropdownMenuItem<LeaveStatus?>(
                      value: LeaveStatus.pending,
                      child: Text('Pending'),
                    ),
                    DropdownMenuItem<LeaveStatus?>(
                      value: LeaveStatus.approved,
                      child: Text('Approved'),
                    ),
                    DropdownMenuItem<LeaveStatus?>(
                      value: LeaveStatus.rejected,
                      child: Text('Rejected'),
                    ),
                  ],
                  onChanged: (s) {
                    setState(() => _selectedStatus = s);
                    _onFilter();
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                  ),
                  style: kCaptionTextStyle(
                    context,
                  ).copyWith(fontWeight: FontWeight.w900, color: kBrown),
                  iconEnabledColor: kBrown,
                ),
              ),
            ),
          ],
        ),
        if (_selectedDate != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Icon(
                  Icons.event,
                  size: 18,
                  color: kBrown.withAlpha((0.9 * 255).toInt()),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Date filter: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                    style: kDescriptionTextStyle(context).copyWith(
                      color: kBrown.withAlpha((0.78 * 255).toInt()),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: kPink),
                  onPressed: () {
                    setState(() => _selectedDate = null);
                    _onFilter();
                  },
                  tooltip: 'Clear date filter',
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      _onFilter();
    }
  }

  void _onFilter() {
    widget.onFilter(
      _searchController.text,
      _selectedDate,
      _selectedEmployee,
      _selectedStatus,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
