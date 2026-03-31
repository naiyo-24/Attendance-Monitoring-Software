import 'package:flutter/material.dart';
import '../../models/break_time.dart';
import '../../services/api_url.dart';
import '../../theme/app_theme.dart';

class BreakTimeDetailsCard extends StatelessWidget {
	final List<BreakTime> breaks;
	const BreakTimeDetailsCard({required this.breaks, super.key});

	@override
	Widget build(BuildContext context) {
		return Center(
			child: Container(
				constraints: const BoxConstraints(maxWidth: 420),
				decoration: BoxDecoration(
					color: kWhite,
					borderRadius: BorderRadius.circular(24),
					boxShadow: [
						BoxShadow(
							color: kBrown.withOpacity(0.08),
							blurRadius: 24,
							offset: const Offset(0, 8),
						),
					],
				),
				child: Padding(
					padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
					child: SingleChildScrollView(
						child: breaks.isEmpty
								? Center(child: Text('No breaks taken on this day.', style: kDescriptionTextStyle(context)))
								: Column(
										mainAxisSize: MainAxisSize.min,
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text('Breaks Taken', style: kHeaderTextStyle(context).copyWith(fontSize: 18)),
											const SizedBox(height: 16),
											...breaks.map((b) => Padding(
														padding: const EdgeInsets.only(bottom: 18.0),
														child: Column(
															crossAxisAlignment: CrossAxisAlignment.start,
															children: [
																Row(
																	crossAxisAlignment: CrossAxisAlignment.start,
																	children: [
																		Expanded(child: Text('Break In: ${b.breakInTime ?? '-'}', style: kDescriptionTextStyle(context))),
																		if (b.breakInPhoto != null && b.breakInPhoto!.isNotEmpty)
																			ClipRRect(
																				borderRadius: BorderRadius.circular(12),
																				child: Padding(
																					padding: const EdgeInsets.only(left: 8.0),
																					child: Image.network(
																						b.breakInPhoto!.startsWith('http') ? b.breakInPhoto! : baseUrl + '/' + b.breakInPhoto!,
																						width: 56,
																						height: 56,
																						fit: BoxFit.cover,
																						errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 40),
																					),
																				),
																			),
																	],
																),
																const SizedBox(height: 8),
																Row(
																	crossAxisAlignment: CrossAxisAlignment.start,
																	children: [
																		Expanded(child: Text('Break Out: ${b.breakOutTime ?? '-'}', style: kDescriptionTextStyle(context))),
																		if (b.breakOutPhoto != null && b.breakOutPhoto!.isNotEmpty)
																			ClipRRect(
																				borderRadius: BorderRadius.circular(12),
																				child: Padding(
																					padding: const EdgeInsets.only(left: 8.0),
																					child: Image.network(
																						b.breakOutPhoto!.startsWith('http') ? b.breakOutPhoto! : baseUrl + '/' + b.breakOutPhoto!,
																						width: 56,
																						height: 56,
																						fit: BoxFit.cover,
																						errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 40),
																					),
																				),
																			),
																	],
																),
															],
														),
													)),
										],
									),
					),
				),
			),
		);
	}
}
