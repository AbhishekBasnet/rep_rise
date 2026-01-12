import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rep_rise/core/theme/app_theme.dart';

class StepBarGraph extends StatelessWidget {
  const StepBarGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsetsGeometry.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // Optional: Adds a subtle shadow like the card in the image
        boxShadow: [AppTheme.stepsCardBoxShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. THE HEADER (Statistics + Dropdown)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Statistics",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Text("Past 7 days", style: TextStyle(fontSize: 12)),
                    SizedBox(width: 4),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 2. THE CHART
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                // Max Y to allow space for the tooltip at the top
                maxY: 10000,
                minY: 0,

                // Hide borders and grid
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),

                // Touch/Tooltip Settings
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    // The Bubble Background Color
                    getTooltipColor: (group) => Colors.white,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    // The Bubble Rounded Corners
                    // Border (Simulated via padding/margin usually, but FL Chart 0.66 might rely on content)
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        // The Text inside the bubble
                        '${rod.toY.toInt()}\n',
                        const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                        children: [
                          const TextSpan(
                            text: 'steps',
                            style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.normal),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Axis Titles
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

                  // Left Titles (Y-Axis: 4k, 5k...)
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 1000, // Show label every 1000 steps
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return Container(); // Hide 0
                        // Convert 4000 -> 4k
                        return Text(
                          '${(value / 1000).toInt()}k',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        );
                      },
                    ),
                  ),

                  // Bottom Titles (Days)
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                        if (value.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              days[value.toInt()],
                              style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),

                // DATA GROUPS (Now using realistic "thousands" values)
                barGroups: [
                  _makeBar(0, 5500, isSelected: false),
                  _makeBar(1, 6600, isSelected: false),
                  _makeBar(2, 4200, isSelected: false),
                  _makeBar(3, 5800, isSelected: false),
                  _makeBar(4, 5289, isSelected: true), // The Highlighted one!
                  _makeBar(5, 7500, isSelected: false),
                  _makeBar(6, 6200, isSelected: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBar(int x, double y, {required bool isSelected}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          // If selected: Dark Purple. If not: Light Purple (Lavender)
          color: isSelected ? const Color(0xFF6B46C1) : const Color(0xFFD0BCFF),
          width: 22, // Slightly wider to match image
          borderRadius: BorderRadius.circular(12), // Fully rounded top AND bottom (Pill shape)
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 8500, // Max height background
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
