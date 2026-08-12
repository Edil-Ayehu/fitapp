import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/progress_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_tab_bar.dart';
import '../../widgets/paywall_modal.dart';
import '../analytics/advanced_analytics_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final progress = Provider.of<ProgressProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final sub = Provider.of<SubscriptionProvider>(context);

    final user = auth.userProfile;
    final bmi = progress.calculateBMI(user.heightCm);

    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141722),
        elevation: 0,
        title: const Text('Progress & Body 📈', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded, color: Color(0xFFD0FD38)),
            onPressed: () {
              if (sub.isFeatureLocked('advanced_analytics')) {
                PaywallModal.show(context, title: 'Unlock Advanced Analytics', subtitle: 'View strength progression curves, volume history & muscle distribution.');
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) => const AdvancedAnalyticsScreen()));
              }
            },
          ),
        ],
        bottom: CustomPillTabBar(
          controller: _tabController,
          tabs: const ['Weight & BMI', 'Measurements', 'Photos'],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. WEIGHT & BMI TAB
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Metrics Overview Card
                Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        borderColor: const Color(0xFFD0FD38),
                        child: Column(
                          children: [
                            const Text('Current Weight', style: TextStyle(color: Colors.white60, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text('${progress.latestWeight} kg', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text('Target: ${user.targetWeightKg} kg', style: const TextStyle(color: Color(0xFFD0FD38), fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassCard(
                        borderColor: const Color(0xFF00E5FF),
                        child: Column(
                          children: [
                            const Text('BMI & Body Fat %', style: TextStyle(color: Colors.white60, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text('$bmi', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text('${progress.latestBodyFat}% Body Fat', style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const Text('Weight Trend (90 Days)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                // fl_chart LineChart for Weight
                GlassCard(
                  child: SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: progress.weightLogs.asMap().entries.map((e) {
                              return FlSpot(e.key.toDouble(), e.value.weightKg);
                            }).toList(),
                            isCurved: true,
                            color: const Color(0xFFD0FD38),
                            barWidth: 4,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: const Color(0xFFD0FD38).withOpacity(0.15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                CustomButton(
                  text: '+ Log Today\'s Weight',
                  onPressed: () => _showAddWeightDialog(context, progress),
                ),
              ],
            ),
          ),

          // 2. MEASUREMENTS TAB
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Body Tape Measurements', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                if (progress.measurements.isNotEmpty)
                  GlassCard(
                    child: Column(
                      children: [
                        _buildMeasurementRow('Chest', '${progress.measurements.last.chestCm} cm', '+2.5 cm'),
                        _buildMeasurementRow('Waist', '${progress.measurements.last.waistCm} cm', '-1.5 cm'),
                        _buildMeasurementRow('Arms (Biceps)', '${progress.measurements.last.armsCm} cm', '+1.3 cm'),
                        _buildMeasurementRow('Thighs', '${progress.measurements.last.thighsCm} cm', '+1.5 cm'),
                        _buildMeasurementRow('Shoulders', '${progress.measurements.last.shouldersCm} cm', '+2.5 cm'),
                        _buildMeasurementRow('Hips', '${progress.measurements.last.hipsCm} cm', '-0.5 cm'),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Log New Measurements',
                  isPrimary: false,
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // 3. PROGRESS PHOTOS TAB
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Before vs After Comparison', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    if (sub.isFeatureLocked('progress_photos_compare'))
                      const Icon(Icons.lock, color: Color(0xFFD0FD38), size: 18),
                  ],
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 220,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2232),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.camera_alt_outlined, color: Colors.white38, size: 40),
                            SizedBox(height: 8),
                            Text('Day 1 (80.0 kg)', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 13)),
                            Text('60 days ago', style: TextStyle(color: Colors.white38, fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 220,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2232),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFD0FD38)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.camera_alt, color: Color(0xFFD0FD38), size: 40),
                            SizedBox(height: 8),
                            Text('Today (78.5 kg)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            Text('Current', style: TextStyle(color: Color(0xFFD0FD38), fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                CustomButton(
                  text: 'Upload Progress Photo',
                  onPressed: () {
                    if (sub.isFeatureLocked('progress_photos_compare')) {
                      PaywallModal.show(context, title: 'Unlock Progress Photos', subtitle: 'Store and compare front, side & back transformation photos.');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select photo from gallery...')));
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementRow(String label, String val, String change) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          Row(
            children: [
              Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(width: 8),
              Text(change, style: const TextStyle(color: Color(0xFFD0FD38), fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddWeightDialog(BuildContext context, ProgressProvider progress) {
    final ctrl = TextEditingController(text: progress.latestWeight.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F2332),
        title: const Text('Log Weight', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Weight in kg', labelStyle: TextStyle(color: Colors.white60)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.white60))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD0FD38), foregroundColor: Colors.black),
            onPressed: () {
              final w = double.tryParse(ctrl.text);
              if (w != null) {
                progress.addWeightEntry(w);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
