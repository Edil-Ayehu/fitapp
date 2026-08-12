import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/progress_ring.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_tab_bar.dart';
import '../../widgets/paywall_modal.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final nutrition = Provider.of<NutritionProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final sub = Provider.of<SubscriptionProvider>(context);

    final user = auth.userProfile;

    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141722),
        elevation: 0,
        title: const Text('Nutrition & Macros 🥗', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        bottom: CustomPillTabBar(
          controller: _tabController,
          tabs: const ['Food Tracker', 'Meal Plans'],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. FOOD TRACKER TAB
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Macro Summary Dashboard Card
                GlassCard(
                  borderColor: const Color(0xFFD0FD38),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProgressRing(
                            progress: (nutrition.totalCaloriesToday / user.targetCalories).clamp(0.0, 1.0),
                            size: 90,
                            strokeWidth: 8,
                            ringColor: const Color(0xFFD0FD38),
                            centerChild: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${nutrition.totalCaloriesToday}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('/ ${user.targetCalories}', style: const TextStyle(color: Colors.white60, fontSize: 10)),
                                const Text('kcal', style: TextStyle(color: Color(0xFFD0FD38), fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMacroBar('Protein', '${nutrition.totalProteinToday}/${user.targetProteinGrams}g', (nutrition.totalProteinToday / user.targetProteinGrams).clamp(0.0, 1.0), const Color(0xFF00E5FF)),
                              const SizedBox(height: 8),
                              _buildMacroBar('Carbs', '${nutrition.totalCarbsToday}/${user.targetCarbsGrams}g', (nutrition.totalCarbsToday / user.targetCarbsGrams).clamp(0.0, 1.0), const Color(0xFFFFB800)),
                              const SizedBox(height: 8),
                              _buildMacroBar('Fat', '${nutrition.totalFatToday}/${user.targetFatGrams}g', (nutrition.totalFatToday / user.targetFatGrams).clamp(0.0, 1.0), Colors.purpleAccent),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Meal Logging Sections
                _buildMealSection(context, 'Breakfast 🍳', 'Breakfast', nutrition),
                _buildMealSection(context, 'Lunch 🍗', 'Lunch', nutrition),
                _buildMealSection(context, 'Dinner 🥩', 'Dinner', nutrition),
                _buildMealSection(context, 'Snacks 🍎', 'Snacks', nutrition),
              ],
            ),
          ),

          // 2. MEAL PLANS TAB
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Custom AI Meal Plans', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    if (sub.isFeatureLocked('meal_planner'))
                      const Icon(Icons.lock, color: Color(0xFFD0FD38), size: 18),
                  ],
                ),
                const SizedBox(height: 12),

                ...nutrition.mealPlans.map((plan) {
                  return GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(plan.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('${plan.totalCalories} kcal', style: const TextStyle(color: Color(0xFFD0FD38), fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildPlanMealRow('Breakfast', plan.breakfast),
                        _buildPlanMealRow('Lunch', plan.lunch),
                        _buildPlanMealRow('Dinner', plan.dinner),
                        _buildPlanMealRow('Snacks', plan.snacks),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),

                CustomButton(
                  text: 'Generate New AI Meal Plan',
                  onPressed: () {
                    if (sub.isFeatureLocked('meal_planner')) {
                      PaywallModal.show(context, title: 'Unlock Meal Planner', subtitle: 'Get personalized meal plans matching your exact macro target.');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('AI Meal Plan Generated! 🥗')));
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

  Widget _buildMacroBar(String label, String valueText, double progress, Color color) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
              Text(valueText, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFF222638),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(BuildContext context, String title, String mealType, NutritionProvider nutrition) {
    final mealEntries = nutrition.loggedMeals.where((m) => m.mealType == mealType).toList();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Color(0xFFD0FD38), size: 20),
                onPressed: () => _showFoodSearchModal(context, mealType, nutrition),
              ),
            ],
          ),
          if (mealEntries.isEmpty)
            const Text('No food logged yet', style: TextStyle(color: Colors.white38, fontSize: 12))
          else
            ...mealEntries.map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Text(e.food.name, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    const Spacer(),
                    Text('${e.totalCalories} kcal • ${e.totalProtein}g P', style: const TextStyle(color: Color(0xFFD0FD38), fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildPlanMealRow(String type, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text(type, style: const TextStyle(color: Color(0xFFD0FD38), fontWeight: FontWeight.bold, fontSize: 12))),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12))),
        ],
      ),
    );
  }

  void _showFoodSearchModal(BuildContext context, String mealType, NutritionProvider nutrition) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141722),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Food to $mealType', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            TextField(
              onChanged: nutrition.setSearchQuery,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search food database (e.g. Chicken)...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1E2232),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: nutrition.filteredFoodDatabase.length,
                itemBuilder: (ctx, idx) {
                  final food = nutrition.filteredFoodDatabase[idx];
                  return ListTile(
                    title: Text(food.name, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    subtitle: Text('${food.calories} kcal per ${food.servingSize} • P: ${food.proteinGrams}g C: ${food.carbsGrams}g F: ${food.fatGrams}g', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    onTap: () {
                      nutrition.logFood(food, mealType, 1.0);
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
