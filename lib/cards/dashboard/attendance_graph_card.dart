import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/attendance_graph.dart';
import '../../theme/app_theme.dart';

class AttendanceGraphCard extends StatelessWidget {
	final AttendanceGraph graph;
	const AttendanceGraphCard({super.key, required this.graph});

	@override
	Widget build(BuildContext context) {
		return Card(
			color: kWhiteGrey,
			margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
			elevation: 2,
			child: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text('Attendance Overview', style: kHeaderTextStyle(context).copyWith(fontSize: 20)),
						const SizedBox(height: 12),
						SizedBox(
							height: 220,
							child: LineChart(
								LineChartData(
									gridData: FlGridData(show: true),
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
													return Text(graph.months[idx], style: kCaptionTextStyle(context));
												},
												interval: 1,
												reservedSize: 32,
											),
										),
										rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
										topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
									),
									borderData: FlBorderData(show: true, border: Border.all(color: kBrown, width: 1)),
									minX: 0,
									maxX: (graph.months.length - 1).toDouble(),
									minY: 0,
									maxY: (graph.present + graph.absent).reduce((a, b) => a > b ? a : b).toDouble() + 2,
									lineBarsData: [
										LineChartBarData(
											spots: List.generate(graph.present.length, (i) => FlSpot(i.toDouble(), graph.present[i].toDouble())),
											isCurved: true,
											color: kGreen,
											barWidth: 3,
											dotData: FlDotData(show: false),
											belowBarData: BarAreaData(show: false),
										),
										LineChartBarData(
											spots: List.generate(graph.absent.length, (i) => FlSpot(i.toDouble(), graph.absent[i].toDouble())),
											isCurved: true,
											color: kPink,
											barWidth: 3,
											dotData: FlDotData(show: false),
											belowBarData: BarAreaData(show: false),
										),
									],
									lineTouchData: LineTouchData(enabled: true),
								),
							),
						),
						const SizedBox(height: 8),
						Row(
							children: [
								_legendDot(kGreen),
								const SizedBox(width: 4),
								Text('Present', style: kCaptionTextStyle(context)),
								const SizedBox(width: 16),
								_legendDot(kPink),
								const SizedBox(width: 4),
								Text('Absent', style: kCaptionTextStyle(context)),
							],
						),
					],
				),
			),
		);
	}

	Widget _legendDot(Color color) {
		return Container(
			width: 12,
			height: 12,
			decoration: BoxDecoration(
				color: color,
				shape: BoxShape.circle,
			),
		);
	}
}
