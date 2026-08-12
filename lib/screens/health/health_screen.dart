import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/health_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/progress_ring.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final health = Provider.of<HealthProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    final user = auth.userProfile;

    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141722),
        elevation: 0,
        title: const Text('Water, Sleep & Steps 💧', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Water Intake Card
            GlassCard(
              borderColor: const Color(0xFF00E5FF),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('WATER HYDRATION', style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 12)),
                      Icon(Icons.water_drop, color: Color(0xFF00E5FF)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ProgressRing(
                    progress: (health.waterLitersToday / user.targetWaterLiters).clamp(0.0, 1.0),
                    size: 100,
                    strokeWidth: 9,
                    ringColor: const Color(0xFF00E5FF),
                    centerChild: Text('${health.waterLitersToday}L', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  const SizedBox(height: 12),
                  Text('Daily Goal: ${user.targetWaterLiters} Liters', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: '+250 ml',
                          isPrimary: false,
                          onPressed: () => health.addWater(250),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomButton(
                          text: '+500 ml',
                          isPrimary: false,
                          onPressed: () => health.addWater(500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sleep Tracker Card
            GlassCard(
              borderColor: Colors.purpleAccent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('SLEEP TRACKER', style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                      Icon(Icons.bedtime, color: Colors.purpleAccent),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${health.latestSleep.durationHours} Hours', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          Text('Bed: ${health.latestSleep.bedtime} • Wake: ${health.latestSleep.wakeTime}', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: List.generate(5, (idx) {
                          return Icon(
                            idx < health.latestSleep.qualityRating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Steps & Activity Card
            GlassCard(
              borderColor: const Color(0xFFFFB800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('DAILY STEPS', style: TextStyle(color: Color(0xFFFFB800), fontWeight: FontWeight.bold, fontSize: 12)),
                      Icon(Icons.directions_walk, color: Color(0xFFFFB800)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${health.stepsToday} Steps', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      Text('${health.distanceKmToday} km', style: const TextStyle(color: Color(0xFFFFB800), fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Health App Sync', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      Switch(
                        value: health.isHealthPlatformSynced,
                        activeColor: const Color(0xFFD0FD38),
                        onChanged: health.toggleHealthPlatformSync,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
