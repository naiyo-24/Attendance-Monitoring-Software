import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../models/salary_slip.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_url.dart';
import '../../widgets/app_bar.dart';
import '../../cards/salary_slip/salary_slip_card.dart';
import '../../providers/salary_slip_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/employee_provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../widgets/side_nav_bar.dart';

class SalarySlipScreen extends ConsumerStatefulWidget {
	const SalarySlipScreen({super.key});

	@override
	ConsumerState<SalarySlipScreen> createState() => _SalarySlipScreenState();
}
class _SalarySlipScreenState extends ConsumerState<SalarySlipScreen> {
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) async {
			final authNotifier = ref.read(authProvider);
			final employeeNotifier = ref.read(employeeNotifierProvider);
			if (authNotifier.user?.adminId != null) {
				// Fetch employees for the current admin
				await employeeNotifier.fetchEmployees(authNotifier.user!.adminId!);
				// Now fetch salary slips for each employee
				for (final emp in employeeNotifier.employees) {
					await ref.read(salarySlipNotifierProvider).fetchSalarySlips(adminId: authNotifier.user!.adminId!, employee: emp);
				}
			}
		});
	}

	Future<void> _pickPdf(int index) async {
		final salarySlipNotifier = ref.read(salarySlipNotifierProvider);
		final authNotifier = ref.read(authProvider);
		final _ = ref.read(employeeNotifierProvider);
		final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
		if (result != null && result.files.single.path != null) {
			final slip = salarySlipNotifier.salarySlips[index];
			final file = File(result.files.single.path!);
			await salarySlipNotifier.uploadOrUpdateSalarySlip(
				adminId: authNotifier.user!.adminId!,
				employee: slip.employee,
				pdfFile: file,
				slipId: slip.slipId,
			);
		}
	}

	Future<void> _deletePdf(int index) async {
		final salarySlipNotifier = ref.read(salarySlipNotifierProvider);
		final slip = salarySlipNotifier.salarySlips[index];
		if (slip.slipId != null) {
			await salarySlipNotifier.deleteSalarySlip(slipId: slip.slipId!);
		}
	}

	void _viewPdf(String? url) async {
		if (url != null) {
			final fullUrl = url.startsWith('http') ? url : baseUrl + url;
			// ignore: deprecated_member_use
			await launchUrlString(fullUrl, mode: LaunchMode.externalApplication);
		}
	}

	@override
	Widget build(BuildContext context) {
		final salarySlipNotifier = ref.watch(salarySlipNotifierProvider);
		final employeeNotifier = ref.watch(employeeNotifierProvider);
		final isLoading = employeeNotifier.isLoading || salarySlipNotifier.isLoading;

		return Scaffold(
			appBar: const PremiumAppBar(
				title: 'Salary Slips',
				subtitle: 'Manage employee salary slips',
			),
			drawer: const SideNavBar(),
			body: Padding(
				padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
				child: isLoading
						? const Center(child: CircularProgressIndicator())
						: employeeNotifier.employees.isEmpty
								? const Center(child: Text('No employees found.'))
								: ListView.builder(
										itemCount: employeeNotifier.employees.length,
										itemBuilder: (context, idx) {
											final emp = employeeNotifier.employees[idx];
											// Find the salary slip for this employee, or create a dummy
											final slip = salarySlipNotifier.salarySlips.firstWhere(
												(s) => s.employee.employeeId == emp.employeeId,
												orElse: () => SalarySlip(employee: emp),
											);
											return SalarySlipCard(
												slip: slip,
												onUploadPdf: () => _pickPdf(idx),
												onViewPdf: slip.salarySlipUrl != null ? () => _viewPdf(slip.salarySlipUrl) : null,
												onDeletePdf: slip.slipId != null ? () => _deletePdf(idx) : null,
											);
										},
									),
			),
		);
	}
}
