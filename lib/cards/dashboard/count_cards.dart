
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/count.dart';
import '../../theme/app_theme.dart';

class CountCards extends StatelessWidget {
	final Count count;
	const CountCards({super.key, required this.count});

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceEvenly,
				children: [
					_buildCard(
						context,
						label: 'Employees',
						value: count.employees,
						icon: Iconsax.profile_2user,
						gradient: const LinearGradient(colors: [kGreen, kGreen]),
						iconColor: kWhite,
					),
					_buildCard(
						context,
						label: 'Holidays',
						value: count.holidays,
						icon: Iconsax.calendar,
						gradient: const LinearGradient(colors: [kPink, kBlack]),
						iconColor: kWhite,
					),
					_buildCard(
						context,
						label: 'Pending Leaves',
						value: count.pendingLeaves,
						icon: Iconsax.document_text,
						gradient: const LinearGradient(colors: [kBrown, kBlack]),
						iconColor: kWhite,
					),
				],
			),
		);
	}

	Widget _buildCard(
		BuildContext context, {
		required String label,
		required int value,
		required IconData icon,
		required Gradient gradient,
		required Color iconColor,
	}) {
		return Container(
			width: 110,
			height: 110,
			margin: const EdgeInsets.symmetric(horizontal: 4),
			decoration: BoxDecoration(
				gradient: gradient,
				borderRadius: BorderRadius.circular(20),
				boxShadow: [
					BoxShadow(
						color: iconColor.withAlpha((0.08 * 255).toInt()),
						blurRadius: 16,
						offset: const Offset(0, 8),
					),
				],
			),
			child: Material(
				color: Colors.transparent,
				child: InkWell(
					borderRadius: BorderRadius.circular(20),
					onTap: () {},
					child: Padding(
						padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
						child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
								Container(
									decoration: BoxDecoration(
										color: iconColor.withAlpha((0.12 * 255).toInt()),
										shape: BoxShape.circle,
									),
									padding: const EdgeInsets.all(7),
									child: Icon(icon, color: iconColor, size: 24),
								),
								const SizedBox(height: 6),
								Text('$value', style: kHeaderTextStyle(context).copyWith(fontSize: 20, color: iconColor)),
								Text(label, style: kCaptionTextStyle(context).copyWith(fontWeight: FontWeight.w600, fontSize: 12, color: kWhite)),
							],
						),
					),
				),
			),
		);
	}
}
