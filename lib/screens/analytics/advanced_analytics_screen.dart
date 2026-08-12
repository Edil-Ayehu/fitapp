import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../widgets/glass_card.dart';

class AdvancedAnalyticsScreen extends StatelessWidget {
  const AdvancedAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Advanced Analytics 📊', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Volume Trend Chart Header
            const Text('Total Training Volume (kg / month)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            GlassCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Monthly Total', style: TextStyle(color: Colors.white60, fontSize: 13)),
                      Text('34,800 kg', style: TextStyle(color: Color(0xFFD0FD38), fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 22000),
                              FlSpot(1, 26500),
                              FlSpot(2, 31000),
                              FlSpot(3, 34800),
                            ],
                            isCurved: true,
                            color: const Color(0xFF00E5FF),
                            barWidth: 4,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(show: true, color: const Color(0xFF00E5FF).withOpacity(0.15)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Muscle Volume Distribution Bar Chart
            const Text('Muscle Group Volume Split', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMuscleBar('Chest', 0.9, '10,400 kg'),
                  _buildMuscleBar('Back', 0.8, '9,200 kg'),
                  _buildMuscleBar('Legs', 0.75, '8,800 kg'),
                  _buildMuscleBar('Shoulders', 0.55, '4,200 kg'),
                  _buildMuscleBar('Arms', 0.45, '3,600 kg'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Strength progression for Bench Press
            const Text('Bench Press Strength Progression', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            GlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _MonthMetric('Jan', '70kg'),
                  _MonthMetric('Feb', '75kg'),
                  _MonthMetric('Mar', '82.5kg'),
                  _MonthMetric('Apr', '90kg'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMuscleBar(String muscle, double percentage, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(muscle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              Text(text, style: const TextStyle(color: Color(0xFFD0FD38), fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 10,
              backgroundColor: const Color(0xFF222638),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD0FD38)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthMetric extends StatelessWidget {
  final String month;
  final String weight;

  const _MonthMetric(this.month, this.weight);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(weight, style: const TextStyle(color: Color(0xFFD0FD38), fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(month, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }
}
