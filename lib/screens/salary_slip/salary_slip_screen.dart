import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../cards/salary_slip/salary_slip_card.dart';
import '../../notifiers/salary_slip_notifier.dart';
import '../../providers/salary_slip_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/employee_provider.dart';
import '../../models/salary_slip.dart';
import 'package:file_picker/file_picker.dart';

import '../../widgets/side_nav_bar.dart';

class SalarySlipScreen extends ConsumerStatefulWidget {
	const SalarySlipScreen({super.key});

	@override
	ConsumerState<SalarySlipScreen> createState() => _SalarySlipScreenState();
}

class _SalarySlipScreenState extends ConsumerState<SalarySlipScreen> {
	late SalarySlipNotifier salarySlipNotifier;

	@override
	void initState() {
		super.initState();
		salarySlipNotifier = SalarySlipNotifier();
		// Demo: one slip per employee
		final employeeNotifier = ref.read(employeeNotifierProvider);
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
		return SalarySlipProvider(
			notifier: salarySlipNotifier,
			child: Scaffold(
				appBar: const PremiumAppBar(
					title: 'Salary Slips',
					subtitle: 'Manage employee salary slips',
				),
				drawer: const SideNavBar(),
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
		);
	}
}
