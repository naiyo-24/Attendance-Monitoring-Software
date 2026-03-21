import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../cards/salary_slip/salary_slip_card.dart';
import '../../notifiers/salary_slip_notifier.dart';
import '../../providers/salary_slip_provider.dart';
import '../../notifiers/employee_notifier.dart';
import '../../providers/employee_provider.dart';
import '../../models/salary_slip.dart';
import 'package:file_picker/file_picker.dart';

class SalarySlipScreen extends StatefulWidget {
	const SalarySlipScreen({super.key});

	@override
	State<SalarySlipScreen> createState() => _SalarySlipScreenState();
}

class _SalarySlipScreenState extends State<SalarySlipScreen> {
	late SalarySlipNotifier salarySlipNotifier;
	late EmployeeNotifier employeeNotifier;

	@override
	void initState() {
		super.initState();
		salarySlipNotifier = SalarySlipNotifier();
		employeeNotifier = EmployeeNotifier();
		// Demo: one slip per employee
		if (salarySlipNotifier.salarySlips.isEmpty) {
			salarySlipNotifier.setSalarySlips(
				employeeNotifier.employees.map((e) => SalarySlip(employee: e)).toList(),
			);
		}
	}

	Future<void> _pickPdf(int index) async {
		final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
		if (result != null && result.files.single.path != null) {
			final slip = salarySlipNotifier.salarySlips[index];
			salarySlipNotifier.updateSalarySlip(index, SalarySlip(employee: slip.employee, pdfPath: result.files.single.path));
			setState(() {});
		}
	}

	void _deletePdf(int index) {
		final slip = salarySlipNotifier.salarySlips[index];
		salarySlipNotifier.updateSalarySlip(index, SalarySlip(employee: slip.employee));
		setState(() {});
	}

	void _viewPdf(String? path) {
		// TODO: Implement PDF viewer integration
		if (path != null) {
			ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Open PDF: $path')));
		}
	}

	@override
	Widget build(BuildContext context) {
		return EmployeeProvider(
			notifier: employeeNotifier,
			child: SalarySlipProvider(
				notifier: salarySlipNotifier,
				child: Scaffold(
					appBar: const PremiumAppBar(
						title: 'Salary Slips',
						subtitle: 'Manage employee salary slips',
					),
					body: Padding(
						padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
						child: ListView.builder(
							itemCount: salarySlipNotifier.salarySlips.length,
							itemBuilder: (context, idx) {
								final slip = salarySlipNotifier.salarySlips[idx];
								return SalarySlipCard(
									slip: slip,
									onUploadPdf: () => _pickPdf(idx),
									onViewPdf: slip.pdfPath != null ? () => _viewPdf(slip.pdfPath) : null,
									onDeletePdf: slip.pdfPath != null ? () => _deletePdf(idx) : null,
								);
							},
						),
					),
				),
			),
		);
	}
}
