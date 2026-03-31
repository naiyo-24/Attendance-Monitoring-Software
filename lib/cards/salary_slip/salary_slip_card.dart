import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
		return Container(
			margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(24),
				color: kWhite.withOpacity(0.7),
				boxShadow: [
					BoxShadow(
						color: kBrown.withOpacity(0.07),
						blurRadius: 24,
						offset: const Offset(0, 8),
					),
				],
				border: Border.all(color: kWhiteGrey, width: 1.5),
				backgroundBlendMode: BlendMode.overlay,
			),
			child: ClipRRect(
				borderRadius: BorderRadius.circular(24),
				child: BackdropFilter(
					filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
					child: Padding(
						padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Row(
									crossAxisAlignment: CrossAxisAlignment.center,
									children: [
										CircleAvatar(
											radius: 28,
											backgroundColor: kGreen.withOpacity(0.12),
											child: Text(emp.name[0], style: kHeaderTextStyle(context).copyWith(fontSize: 22)),
										),
										const SizedBox(width: 18),
										Expanded(
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Row(
														children: [
															Icon(Iconsax.user, color: kBrown, size: 18),
															const SizedBox(width: 6),
															Flexible(
																child: Text(emp.name, style: kHeaderTextStyle(context).copyWith(fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
															),
														],
													),
													const SizedBox(height: 2),
													Row(
														children: [
															Icon(Iconsax.call, color: kGreen, size: 16),
															const SizedBox(width: 6),
															Flexible(
																child: Text(emp.phone, style: kDescriptionTextStyle(context).copyWith(color: kBrown, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
															),
														],
													),
													const SizedBox(height: 2),
													Row(
														children: [
															Icon(Iconsax.user_tag, color: kBrown, size: 16),
															const SizedBox(width: 6),
															Flexible(
																child: Text(emp.designation, style: kTaglineTextStyle(context).copyWith(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
															),
														],
													),
												],
											),
										),
									],
								),
								const SizedBox(height: 18),
								Row(
									children: [
										Expanded(
											child: ElevatedButton.icon(
												onPressed: onUploadPdf,
												icon: const Icon(Iconsax.document_upload, size: 18),
												label: const Text('Upload PDF'),
												style: kPremiumButtonStyle(context),
											),
										),
										const SizedBox(width: 10),
										Expanded(
											child: ElevatedButton.icon(
												onPressed: slip.salarySlipUrl != null ? onViewPdf : null,
												icon: const Icon(Iconsax.document, size: 18),
												label: const Text('View PDF'),
												style: kPremiumButtonStyle(context).copyWith(
													backgroundColor: WidgetStateProperty.all(kBrown),
													foregroundColor: WidgetStateProperty.all(Colors.white),
												),
											),
										),
										const SizedBox(width: 10),
										Expanded(
											child: ElevatedButton.icon(
												onPressed: slip.slipId != null ? onDeletePdf : null,
												icon: const Icon(Iconsax.trash, size: 18),
												label: const Text('Delete'),
												style: kPremiumButtonStyle(context).copyWith(
													backgroundColor: WidgetStateProperty.all(kerror),
													foregroundColor: WidgetStateProperty.all(Colors.white),
												),
											),
										),
									],
								),
								
							],
						),
					),
				),
			),
		);
	}
}
