import 'package:flutter/material.dart';
import '../../models/salary_slip.dart';
import '../../theme/app_theme.dart';

class SalarySlipCard extends StatelessWidget {
	final SalarySlip slip;
	final VoidCallback? onUploadPdf;
	final VoidCallback? onViewPdf;
	final VoidCallback? onDeletePdf;
	const SalarySlipCard({super.key, required this.slip, this.onUploadPdf, this.onViewPdf, this.onDeletePdf});

	@override
	Widget build(BuildContext context) {
		final emp = slip.employee;
		return Card(
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
			color: kWhiteGrey,
			elevation: 1.5,
			margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
			child: Padding(
				padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Row(
							children: [
								CircleAvatar(
									backgroundColor: kGreen.withAlpha((0.15 * 255).toInt()),
									child: Text(emp.name[0], style: kHeaderTextStyle(context).copyWith(fontSize: 18)),
								),
								const SizedBox(width: 12),
								Expanded(
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text(emp.name, style: kHeaderTextStyle(context).copyWith(fontSize: 18)),
											Text(emp.phone, style: kDescriptionTextStyle(context).copyWith(color: kBrown)),
											Text(emp.designation, style: kTaglineTextStyle(context)),
										],
									),
								),
							],
						),
						const SizedBox(height: 12),
						Row(
							children: [
								ElevatedButton.icon(
									onPressed: onUploadPdf,
									icon: const Icon(Icons.upload_file, size: 18),
									label: const Text('Upload PDF'),
									style: kPremiumButtonStyle(context),
								),
								const SizedBox(width: 10),
								ElevatedButton.icon(
									onPressed: slip.salarySlipUrl != null ? onViewPdf : null,
									icon: const Icon(Icons.picture_as_pdf, size: 18),
									label: const Text('View PDF', style: TextStyle(color: Colors.white)),
									style: kPremiumButtonStyle(context).copyWith(
										backgroundColor: WidgetStateProperty.all(kBrown),
										foregroundColor: WidgetStateProperty.all(Colors.white),
									),
								),
								const SizedBox(width: 10),
								ElevatedButton.icon(
									onPressed: slip.slipId != null ? onDeletePdf : null,
									icon: const Icon(Icons.delete, size: 18),
									label: const Text('Delete PDF', style: TextStyle(color: Colors.white)),
									style: kPremiumButtonStyle(context).copyWith(
										backgroundColor: WidgetStateProperty.all(kerror),
										foregroundColor: WidgetStateProperty.all(Colors.white),
									),
								),
							],
						),
						if (slip.salarySlipUrl != null)
							Padding(
								padding: const EdgeInsets.only(top: 8.0),
								child: Text('PDF: ${slip.salarySlipUrl}', style: kCaptionTextStyle(context)),
							),
					],
				),
			),
		);
	}
}
