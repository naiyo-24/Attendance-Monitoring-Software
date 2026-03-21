import 'package:flutter/material.dart';
import '../../models/leaves.dart';
import '../../theme/app_theme.dart';

class LeaveRequestCard extends StatelessWidget {
	final Leave leave;
	final VoidCallback? onApprove;
	final VoidCallback? onReject;
	const LeaveRequestCard({super.key, required this.leave, this.onApprove, this.onReject});

	@override
	Widget build(BuildContext context) {
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
									child: Text(leave.employee.name[0], style: kHeaderTextStyle(context).copyWith(fontSize: 18)),
								),
								const SizedBox(width: 12),
								Expanded(
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text(leave.employee.name, style: kHeaderTextStyle(context).copyWith(fontSize: 18)),
											Text(leave.employee.phone, style: kDescriptionTextStyle(context).copyWith(color: kBrown)),
										],
									),
								),
								_statusChip(context, leave.status),
							],
						),
						const SizedBox(height: 10),
						Row(
							children: [
								const Icon(Icons.calendar_today, size: 18, color: kBrown),
								const SizedBox(width: 6),
								Text('Date: ${leave.date.toLocal().toString().split(' ')[0]}', style: kDescriptionTextStyle(context)),
							],
						),
						const SizedBox(height: 6),
						Row(
							children: [
								const Icon(Icons.info_outline, size: 18, color: kBrown),
								const SizedBox(width: 6),
								Expanded(child: Text('Reason: ${leave.reason}', style: kDescriptionTextStyle(context))),
							],
						),
						const SizedBox(height: 10),
						if (leave.status == LeaveStatus.pending)
							Row(
								children: [
									ElevatedButton(
										onPressed: onApprove,
										style: kPremiumButtonStyle(context).copyWith(backgroundColor: WidgetStateProperty.all(kGreen)),
										child: const Text('Approve'),
									),
									const SizedBox(width: 10),
									ElevatedButton(
										onPressed: onReject,
										style: kPremiumButtonStyle(context).copyWith(backgroundColor: WidgetStateProperty.all(kPink)),
										child: const Text('Reject'),
									),
								],
							),
					],
				),
			),
		);
	}

	Widget _statusChip(BuildContext context, LeaveStatus status) {
		Color color;
		String label;
		switch (status) {
			case LeaveStatus.pending:
				color = kBrown;
				label = 'Pending';
				break;
			case LeaveStatus.approved:
				color = kGreen;
				label = 'Approved';
				break;
			case LeaveStatus.rejected:
				color = kPink;
				label = 'Rejected';
				break;
		}
		return Chip(
			label: Text(label, style: kTaglineTextStyle(context).copyWith(color: kWhite, fontSize: 13)),
			backgroundColor: color,
			padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
		);
	}
}
