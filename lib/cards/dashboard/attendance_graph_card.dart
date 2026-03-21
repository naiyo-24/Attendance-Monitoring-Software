
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/attendance_graph.dart';
import '../../theme/app_theme.dart';

class AttendanceGraphCard extends StatelessWidget {
	final AttendanceGraph graph;
	const AttendanceGraphCard({super.key, required this.graph});

	@override
	Widget build(BuildContext context) {
		return Container(
			margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(28),
				gradient: const LinearGradient(
					colors: [kWhite, kWhiteGrey],
					begin: Alignment.topLeft,
					end: Alignment.bottomRight,
				),
				boxShadow: [
					BoxShadow(
						color: kGreen.withAlpha((0.08 * 255).toInt()),
						blurRadius: 24,
						offset: const Offset(0, 12),
					),
				],
			),
			child: Padding(
				padding: const EdgeInsets.all(22.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Row(
							children: [
								Container(
									decoration: BoxDecoration(
										color: kGreen.withAlpha((0.12 * 255).toInt()),
										shape: BoxShape.circle,
									),
									padding: const EdgeInsets.all(10),
									child: const Icon(Iconsax.chart, color: kGreen, size: 28),
								),
								const SizedBox(width: 12),
								Text('Attendance Overview', style: kHeaderTextStyle(context).copyWith(fontSize: 22)),
							],
						),
						const SizedBox(height: 18),
						SizedBox(
							height: 300,
							child: LineChart(
								LineChartData(
									gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 5, getDrawingHorizontalLine: (value) => FlLine(color: kWhiteGrey, strokeWidth: 1)),
									titlesData: FlTitlesData(
										leftTitles: AxisTitles(
											sideTitles: SideTitles(showTitles: true, reservedSize: 32),
										),
										bottomTitles: AxisTitles(
											sideTitles: SideTitles(
												showTitles: true,
												getTitlesWidget: (value, meta) {
													int idx = value.toInt();
													if (idx < 0 || idx >= graph.months.length) return const SizedBox();
													return Padding(
														padding: const EdgeInsets.only(top: 6.0),
														child: Text(graph.months[idx], style: kCaptionTextStyle(context)),
													);
												},
												interval: 1,
												reservedSize: 32,
											),
										),
										rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
										topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
									),
									borderData: FlBorderData(show: false),
									minX: 0,
									maxX: (graph.months.length - 1).toDouble(),
									minY: 0,
									maxY: (graph.present + graph.absent).reduce((a, b) => a > b ? a : b).toDouble() + 2,
									lineBarsData: [
										LineChartBarData(
											spots: List.generate(graph.present.length, (i) => FlSpot(i.toDouble(), graph.present[i].toDouble())),
											isCurved: true,
											color: kGreen,
											barWidth: 4,
											dotData: FlDotData(show: true, getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(radius: 4, color: kGreen, strokeWidth: 0)),
											belowBarData: BarAreaData(show: true, color: kGreen.withAlpha((0.08 * 255).toInt())),
										),
										LineChartBarData(
											spots: List.generate(graph.absent.length, (i) => FlSpot(i.toDouble(), graph.absent[i].toDouble())),
											isCurved: true,
											color: kPink,
											barWidth: 4,
											dotData: FlDotData(show: true, getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(radius: 4, color: kPink, strokeWidth: 0)),
											belowBarData: BarAreaData(show: true, color: kPink.withAlpha((0.08 * 255).toInt())),
										),
									],
									lineTouchData: LineTouchData(
										enabled: true,
										touchTooltipData: LineTouchTooltipData(
											getTooltipColor: (bar) => kWhite,
											getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
												final isPresent = spot.barIndex == 0;
												return LineTooltipItem(
													isPresent ? 'Present: ' : 'Absent: ',
													kCaptionTextStyle(context).copyWith(fontWeight: FontWeight.bold, color: isPresent ? kGreen : kPink),
													children: [
														TextSpan(
															text: spot.y.toInt().toString(),
															style: kHeaderTextStyle(context).copyWith(fontSize: 16, color: isPresent ? kGreen : kPink),
														),
													],
												);
											}).toList(),
										),
									),
								),
							),
						),
						const SizedBox(height: 16),
						Row(
							children: [
								_legendDot(kGreen, Iconsax.user_tick, 'Present', context),
								const SizedBox(width: 18),
								_legendDot(kPink, Iconsax.user_remove, 'Absent', context),
							],
						),
					],
				),
			),
		);
	}

	Widget _legendDot(Color color, IconData icon, String label, BuildContext context) {
		return Row(
			children: [
				Container(
					width: 18,
					height: 18,
					decoration: BoxDecoration(
						color: color.withAlpha((0.15 * 255).toInt()),
						shape: BoxShape.circle,
					),
					child: Icon(icon, color: color, size: 14),
				),
				const SizedBox(width: 6),
				Text(label, style: kCaptionTextStyle(context)),
			],
		);
	}
}
