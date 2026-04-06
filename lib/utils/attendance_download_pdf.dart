import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../services/attendance_services.dart';
import '../services/break_time_services.dart';
import '../models/break_time.dart';

class DownloadSheet extends StatefulWidget {
	final List<Map<String, dynamic>> employees;
	final int adminId;
	const DownloadSheet({required this.employees, required this.adminId, super.key});

	@override
	State<DownloadSheet> createState() => _DownloadSheetState();
}

class _DownloadSheetState extends State<DownloadSheet> {
		final AttendanceService _attendanceService = AttendanceService();
		final BreakTimeService _breakTimeService = BreakTimeService();
		bool _isLoading = false;
	int? selectedEmployeeId;
	int selectedMonth = DateTime.now().month;
	int selectedYear = DateTime.now().year;

	Future<void> _downloadPdf() async {
		if (selectedEmployeeId == null) return;
		setState(() => _isLoading = true);
		try {
			final _ = ScaffoldMessenger.of(context);
			final selectedEmployee = widget.employees.firstWhere(
				(e) => e['id'] == selectedEmployeeId,
				orElse: () => <String, dynamic>{},
			);
			final employeeName = (selectedEmployee['name'] ?? '').toString();

			// Fetch attendance data
			final attendanceList = await _attendanceService.fetchAttendanceByAdminAndEmployee(widget.adminId, selectedEmployeeId!);
			// Filter by selected month/year
			final filteredAttendance = attendanceList.where((a) {
				final date = DateTime.tryParse(a.date);
				return date != null && date.month == selectedMonth && date.year == selectedYear;
			}).toList();

			// Fetch all breaks for this employee
			final breakList = await _breakTimeService.fetchBreaksByAdminAndEmployee(widget.adminId, selectedEmployeeId!);

			// Group breaks by attendanceId for quick lookup
			final breaksByAttendance = <int, List<BreakTime>>{};
			for (final b in breakList) {
				breaksByAttendance.putIfAbsent(b.attendanceId, () => []).add(b);
			}

			// Generate PDF
			final pdf = pw.Document();
			pdf.addPage(
				pw.MultiPage(
					pageFormat: PdfPageFormat.a4,
					build: (context) {
						return [
							pw.Text('Attendance Sheet', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
							pw.SizedBox(height: 8),
							pw.Text('Employee: $employeeName'),
							pw.Text('Month: ${selectedMonth.toString().padLeft(2, '0')} / $selectedYear'),
							pw.SizedBox(height: 16),
							pw.TableHelper.fromTextArray(
								headers: [
									'Date',
									'Check In',
									'Check Out',
									'Break In',
									'Break Out',
									'Total Work (h)',
								],
								data: filteredAttendance.map((a) {
									final breaks = breaksByAttendance[a.attendanceId] ?? [];
									final breakIn = breaks.isNotEmpty ? (breaks.first.breakInTime ?? '-') : '-';
									final breakOut = breaks.isNotEmpty ? (breaks.last.breakOutTime ?? '-') : '-';
									final checkIn = a.checkInTime ?? '-';
									final checkOut = a.checkOutTime ?? '-';
									// Calculate total work hours (excluding breaks)
									double totalHours = 0;
									if (a.checkInTime != null && a.checkOutTime != null) {
										final inTime = DateTime.tryParse('${a.date} ${a.checkInTime}');
										final outTime = DateTime.tryParse('${a.date} ${a.checkOutTime}');
										if (inTime != null && outTime != null && outTime.isAfter(inTime)) {
											totalHours = outTime.difference(inTime).inMinutes / 60.0;
											// Subtract break durations
											for (final br in breaks) {
												if (br.breakInTime != null && br.breakOutTime != null) {
													final bin = DateTime.tryParse('${a.date} ${br.breakInTime}');
													final bout = DateTime.tryParse('${a.date} ${br.breakOutTime}');
													if (bin != null && bout != null && bout.isAfter(bin)) {
														totalHours -= bout.difference(bin).inMinutes / 60.0;
													}
												}
											}
											if (totalHours < 0) totalHours = 0;
										}
									}
									return [
										a.date,
										checkIn,
										checkOut,
										breakIn,
										breakOut,
										totalHours.toStringAsFixed(2),
									];
								}).toList(),
								cellStyle: pw.TextStyle(fontSize: 10),
								headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
								cellAlignment: pw.Alignment.center,
								headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
							),
						];
					},
				),
			);

			await Printing.layoutPdf(onLayout: (format) async => pdf.save());
		} catch (e) {
			if (!mounted) return;
			ScaffoldMessenger.of(context).showSnackBar(
				SnackBar(content: Text('Failed to generate PDF: $e')),
			);
		} finally {
			if (mounted) setState(() => _isLoading = false);
		}
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			decoration: BoxDecoration(
				color: kWhite,
				borderRadius: BorderRadius.circular(24),
				boxShadow: [
					BoxShadow(
						color: kBrown.withAlpha(8),
						blurRadius: 24,
						offset: const Offset(0, 8),
					),
				],
			),
			padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
			child: Column(
				mainAxisSize: MainAxisSize.min,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text('Download Attendance Sheet', style: kHeaderTextStyle(context).copyWith(fontSize: 18)),
					const SizedBox(height: 18),
					Text('Employee', style: kCaptionTextStyle(context)),
					const SizedBox(height: 6),
					DropdownButtonFormField<int>(
						initialValue: selectedEmployeeId,
						hint: const Text('Select Employee'),
						items: widget.employees.map((e) {
							return DropdownMenuItem<int>(
								value: e['id'],
								child: Text(e['name']),
							);
						}).toList(),
						onChanged: (val) => setState(() => selectedEmployeeId = val),
						decoration: InputDecoration(
							filled: true,
							fillColor: kWhiteGrey,
							border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
							contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
						),
					),
					const SizedBox(height: 14),
					Row(
						children: [
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text('Month', style: kCaptionTextStyle(context)),
										const SizedBox(height: 6),
										DropdownButtonFormField<int>(
											initialValue: selectedMonth,
											items: List.generate(12, (i) => DropdownMenuItem(
												value: i + 1,
												child: Text('${i + 1}'.padLeft(2, '0')),
											)),
											onChanged: (val) => setState(() => selectedMonth = val ?? selectedMonth),
											decoration: InputDecoration(
												filled: true,
												fillColor: kWhiteGrey,
												border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
												contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
											),
										),
									],
								),
							),
							const SizedBox(width: 16),
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text('Year', style: kCaptionTextStyle(context)),
										const SizedBox(height: 6),
										DropdownButtonFormField<int>(
											initialValue: selectedYear,
											items: List.generate(6, (i) {
												int year = DateTime.now().year - 3 + i;
												return DropdownMenuItem(
													value: year,
													child: Text('$year'),
												);
											}),
											onChanged: (val) => setState(() => selectedYear = val ?? selectedYear),
											decoration: InputDecoration(
												filled: true,
												fillColor: kWhiteGrey,
												border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
												contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
											),
										),
									],
								),
							),
						],
					),
					const SizedBox(height: 24),
					Center(
						child: _isLoading
								? const CircularProgressIndicator()
								: ElevatedButton.icon(
										icon: const Icon(Icons.picture_as_pdf),
										label: const Text('Download PDF'),
										style: kPremiumButtonStyle(context),
										onPressed: selectedEmployeeId == null ? null : _downloadPdf,
									),
					),
				],
			),
		);
	}
}
