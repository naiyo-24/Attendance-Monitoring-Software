import 'package:flutter/material.dart';
import '../../models/help_center.dart';
import '../../theme/app_theme.dart';

class HeaderCard extends StatelessWidget {
	final HelpCenter helpCenter;
	const HeaderCard({super.key, required this.helpCenter});

	@override
	Widget build(BuildContext context) {
		return Card(
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
			color: kWhite,
			elevation: 2,
			margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
			child: Padding(
				padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
				child: Row(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						ClipRRect(
							borderRadius: BorderRadius.circular(12),
							child: Image.asset(
								helpCenter.logoPath,
								width: 72,
								height: 72,
								fit: BoxFit.cover,
							),
						),
						const SizedBox(width: 18),
						Expanded(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(helpCenter.header, style: kHeaderTextStyle(context)),
									const SizedBox(height: 4),
									Text(helpCenter.tagline, style: kTaglineTextStyle(context)),
									const SizedBox(height: 10),
									Text(helpCenter.description, style: kDescriptionTextStyle(context)),
								],
							),
						),
					],
				),
			),
		);
	}
}
