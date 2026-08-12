import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/workout_provider.dart';
import '../../providers/active_workout_provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../providers/health_provider.dart';
import '../../providers/progress_provider.dart';
import '../../providers/subscription_provider.dart';

import '../../widgets/glass_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/progress_ring.dart';

import '../workout/workout_tab_screen.dart';
import '../live_workout/live_workout_screen.dart';
import '../progress/progress_screen.dart';
import '../nutrition/nutrition_screen.dart';
import '../ai_coach/ai_coach_screen.dart';
import '../settings/settings_screen.dart';
import '../../widgets/paywall_modal.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const _DashboardHomeView(),
      const WorkoutTabScreen(),
      const ProgressScreen(),
      const NutritionScreen(),
      const AICoachScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: const Color(0xFF141722),
        selectedItemColor: const Color(0xFFD0FD38),
        unselectedItemColor: Colors.white.withOpacity(0.4),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarViewItem(icon: Icon(Icons.grid_view_rounded), label: 'Home'),
          BottomNavigationBarViewItem(icon: Icon(Icons.fitness_center), label: 'Workouts'),
          BottomNavigationBarViewItem(icon: Icon(Icons.show_chart), label: 'Progress'),
          BottomNavigationBarViewItem(icon: Icon(Icons.restaurant_menu), label: 'Nutrition'),
          BottomNavigationBarViewItem(icon: Icon(Icons.smart_toy_outlined), label: 'AI Coach'),
        ],
      ),
    );
  }
}

class BottomNavigationBarViewItem extends BottomNavigationBarItem {
  const BottomNavigationBarViewItem({required super.icon, required super.label});
}

class _DashboardHomeView extends StatelessWidget {
  const _DashboardHomeView();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final workout = Provider.of<WorkoutProvider>(context);
    final activeWorkout = Provider.of<ActiveWorkoutProvider>(context);
    final nutrition = Provider.of<NutritionProvider>(context);
    final health = Provider.of<HealthProvider>(context);
    final progress = Provider.of<ProgressProvider>(context);
    final sub = Provider.of<SubscriptionProvider>(context);

    final user = auth.userProfile;
    final todayRoutine = workout.customRoutines.isNotEmpty
        ? workout.customRoutines.first
        : workout.allPrograms.first.routines.first;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar Profile Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${user.name.split(' ')[0]} 👋',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Goal: ${user.primaryGoal}',
                      style: const TextStyle(color: Color(0xFFD0FD38), fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings_outlined, color: Colors.white),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const SettingsScreen())),
                    ),
                    GestureDetector(
                      onTap: () => PaywallModal.show(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: sub.isPremium ? const Color(0xFFD0FD38) : const Color(0xFF222533),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          sub.isPremium ? 'PRO' : 'UPGRADE',
                          style: TextStyle(
                            color: sub.isPremium ? Colors.black : const Color(0xFFD0FD38),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Streak 🔥 Banner
            GlassCard(
              borderColor: const Color(0xFFFF6B00).withOpacity(0.5),
              child: Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '7 Day Streak!',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'You\'re 82% toward your weekly goal. 3 workouts remaining this week.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Today's Workout Card
            GlassCard(
              borderColor: const Color(0xFFD0FD38),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'TODAY\'S WORKOUT',
                        style: TextStyle(color: Color(0xFFD0FD38), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.0),
                      ),
                      Text('55 MINS', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    todayRoutine.title,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${todayRoutine.exercises.length} Exercises • ${todayRoutine.category}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: activeWorkout.hasActiveSession ? 'Resume Live Workout ⏱️' : 'Start Workout',
                    icon: Icons.play_arrow_rounded,
                    onPressed: () {
                      if (!activeWorkout.hasActiveSession) {
                        activeWorkout.startWorkout(todayRoutine, workout.prs);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (ctx) => const LiveWorkoutScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Daily Progress Summary Metrics (Rings & Stats)
            const Text(
              'Daily Summary',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: GlassCard(
                    child: Column(
                      children: [
                        ProgressRing(
                          progress: (nutrition.totalCaloriesToday / user.targetCalories).clamp(0.0, 1.0),
                          size: 70,
                          strokeWidth: 7,
                          ringColor: const Color(0xFFD0FD38),
                          centerChild: const Icon(Icons.local_fire_department, color: Color(0xFFD0FD38), size: 24),
                        ),
                        const SizedBox(height: 8),
                        Text('${nutrition.totalCaloriesToday} / ${user.targetCalories}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        const Text('Calories Burned/Eaten', style: TextStyle(color: Colors.white60, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlassCard(
                    child: Column(
                      children: [
                        ProgressRing(
                          progress: (health.waterLitersToday / user.targetWaterLiters).clamp(0.0, 1.0),
                          size: 70,
                          strokeWidth: 7,
                          ringColor: const Color(0xFF00E5FF),
                          centerChild: const Icon(Icons.water_drop, color: Color(0xFF00E5FF), size: 24),
                        ),
                        const SizedBox(height: 8),
                        Text('${health.waterLitersToday}L / ${user.targetWaterLiters}L', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        const Text('Water Hydration', style: TextStyle(color: Colors.white60, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.directions_walk, color: Color(0xFFFFB800)),
                            Text('STEPS', style: TextStyle(color: Colors.white60, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('${health.stepsToday}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('${health.distanceKmToday} km • ${health.activeCaloriesBurnedToday} kcal', style: const TextStyle(color: Colors.white60, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.monitor_weight_outlined, color: Colors.purpleAccent),
                            Text('WEIGHT', style: TextStyle(color: Colors.white60, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('${progress.latestWeight} kg', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Target: ${user.targetWeightKg} kg', style: const TextStyle(color: Colors.white60, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text(
              'Quick Actions',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Quick Actions Horizontal List
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickActionButton(
                    icon: Icons.add_circle_outline,
                    label: 'Log Water',
                    color: const Color(0xFF00E5FF),
                    onTap: () {
                      health.addWater(250);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added +250ml Water! 💧')),
                      );
                    },
                  ),
                  _buildQuickActionButton(
                    icon: Icons.monitor_weight,
                    label: 'Log Weight',
                    color: Colors.purpleAccent,
                    onTap: () => _showLogWeightDialog(context, progress),
                  ),
                  _buildQuickActionButton(
                    icon: Icons.restaurant,
                    label: 'Log Food',
                    color: const Color(0xFFD0FD38),
                    onTap: () => _showLogFoodQuickDialog(context, nutrition),
                  ),
                  _buildQuickActionButton(
                    icon: Icons.timer,
                    label: 'Rest Timer',
                    color: Colors.orangeAccent,
                    onTap: () => _showRestTimerQuickDialog(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            // AI Coach Promo Card
            GlassCard(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const AICoachScreen())),
              borderColor: const Color(0xFF00E5FF),
              child: Row(
                children: [
                  const Text('🤖', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Ask AI Coach', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 2),
                        Text('"I only have 30 minutes today. Modify my workout!"', style: TextStyle(color: Colors.white60, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Color(0xFF00E5FF), size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1E2B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  void _showLogWeightDialog(BuildContext context, ProgressProvider progress) {
    final ctrl = TextEditingController(text: progress.latestWeight.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F2332),
        title: const Text('Log Today\'s Weight', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Weight (kg)', labelStyle: TextStyle(color: Colors.white60)),
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
            child: const Text('Save Log'),
          ),
        ],
      ),
    );
  }

  void _showLogFoodQuickDialog(BuildContext context, NutritionProvider nutrition) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F2332),
        title: const Text('Quick Log Food', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: nutrition.foodDatabase.take(4).map((food) {
            return ListTile(
              title: Text(food.name, style: const TextStyle(color: Colors.white, fontSize: 14)),
              subtitle: Text('${food.calories} kcal • ${food.proteinGrams}g Protein', style: const TextStyle(color: Colors.white60, fontSize: 12)),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle, color: Color(0xFFD0FD38)),
                onPressed: () {
                  nutrition.logFood(food, 'Snacks', 1.0);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged ${food.name}! 🥗')));
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showRestTimerQuickDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F2332),
        title: const Text('Quick Rest Timer ⏱️', style: TextStyle(color: Colors.white)),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [30, 60, 90, 120].map((s) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF222533)),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rest timer set for ${s}s!')));
              },
              child: Text('${s}s', style: const TextStyle(color: Color(0xFF00E5FF))),
            );
          }).toList(),
        ),
      ),
    );
  }
}
