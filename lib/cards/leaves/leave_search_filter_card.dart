import 'package:flutter/material.dart';
import '../../models/employee.dart';
import '../../providers/employee_provider.dart';
import '../../theme/app_theme.dart';

class LeaveSearchFilterCard extends StatefulWidget {
	final void Function(String search, DateTime? date, Employee? employee) onFilter;
	const LeaveSearchFilterCard({super.key, required this.onFilter});

	@override
	State<LeaveSearchFilterCard> createState() => _LeaveSearchFilterCardState();
}

class _LeaveSearchFilterCardState extends State<LeaveSearchFilterCard> {
	final TextEditingController _searchController = TextEditingController();
	DateTime? _selectedDate;
	Employee? _selectedEmployee;

	@override
	Widget build(BuildContext context) {
		// Use EmployeeNotifier from provider context
		final employeeNotifier = EmployeeProvider.of(context);
		final employees = employeeNotifier.employees;
		return Card(
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
			color: kWhite,
			elevation: 1.5,
			child: Padding(
				padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Row(
							children: [
								Expanded(
									child: TextField(
										controller: _searchController,
										decoration: InputDecoration(
											hintText: 'Search by reason or phone...',
											prefixIcon: const Icon(Icons.search, color: kBrown),
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(12),
												borderSide: BorderSide(color: kWhiteGrey),
											),
											filled: true,
											fillColor: kWhiteGrey,
											contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
										),
										onChanged: (_) => _onFilter(),
									),
								),
								const SizedBox(width: 12),
								IconButton(
									icon: const Icon(Icons.filter_alt, color: kGreen),
									onPressed: _showDatePicker,
									tooltip: 'Filter by date',
								),
							],
						),
						const SizedBox(height: 10),
						DropdownButtonFormField<Employee>(
							value: _selectedEmployee != null && employees.contains(_selectedEmployee)
									? _selectedEmployee
									: null,
							items: [
								const DropdownMenuItem<Employee>(
									value: null,
									child: Text('All Employees'),
								),
								...employees.map((e) => DropdownMenuItem<Employee>(
									value: e,
									child: Text(e.name),
								)),
							],
							onChanged: (emp) {
								setState(() => _selectedEmployee = emp);
								_onFilter();
							},
							decoration: InputDecoration(
								labelText: 'Employee',
								border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
								filled: true,
								fillColor: kWhiteGrey,
								contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
							),
						),
						if (_selectedDate != null)
							Padding(
								padding: const EdgeInsets.only(top: 8.0),
								child: Row(
									children: [
										Text('Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}', style: kDescriptionTextStyle(context)),
										IconButton(
											icon: const Icon(Icons.close, size: 18, color: kPink),
											onPressed: () => setState(() { _selectedDate = null; _onFilter(); }),
											tooltip: 'Clear date filter',
										),
									],
								),
							),
					],
				),
			),
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
		);
	}

	@override
	void dispose() {
		_searchController.dispose();
		super.dispose();
	}
}
