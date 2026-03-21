import 'package:flutter/material.dart';
import '../../models/count.dart';
import '../../theme/app_theme.dart';

class CountCards extends StatelessWidget {
	final Count count;
	const CountCards({super.key, required this.count});

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceEvenly,
				children: [
					_buildCard(context, 'Employees', count.employees, Icons.people, kGreen),
					_buildCard(context, 'Holidays', count.holidays, Icons.calendar_today, kPink),
					_buildCard(context, 'Pending Leaves', count.pendingLeaves, Icons.beach_access, kBrown),
				],
			),
		);
	}

	Widget _buildCard(BuildContext context, String label, int value, IconData icon, Color color) {
		return Card(
			color: kWhiteGrey,
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
			elevation: 2,
			child: Container(
				width: 110,
				height: 100,
				padding: const EdgeInsets.all(16),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						Icon(icon, color: color, size: 32),
						const SizedBox(height: 8),
						Text('$value', style: kHeaderTextStyle(context).copyWith(fontSize: 22)),
						Text(label, style: kCaptionTextStyle(context)),
					],
				),
			),
		);
	}
}
