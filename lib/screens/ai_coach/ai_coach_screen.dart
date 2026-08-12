import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ai_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/workout_provider.dart';
import '../../providers/subscription_provider.dart';

import '../../widgets/glass_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/paywall_modal.dart';

class AICoachScreen extends StatefulWidget {
  const AICoachScreen({super.key});

  @override
  State<AICoachScreen> createState() => _AICoachScreenState();
}

class _AICoachScreenState extends State<AICoachScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _msgController = TextEditingController();

  // Wizard state for AI generator
  String _selectedGoal = 'Build muscle';
  int _selectedDays = 4;
  int _selectedDuration = 60;
  String _selectedEquipment = 'Full Gym';
  String _selectedLevel = 'Intermediate';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final ai = Provider.of<AIProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final workout = Provider.of<WorkoutProvider>(context);
    final sub = Provider.of<SubscriptionProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141722),
        elevation: 0,
        title: const Text('AI Personal Trainer 🤖', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF00E5FF),
          labelColor: const Color(0xFF00E5FF),
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'AI Chat'),
            Tab(text: 'Workout Wizard'),
            Tab(text: 'Progress Report'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. AI CHAT TAB
          Column(
            children: [
              // Messages area
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: ai.messages.length,
                  itemBuilder: (ctx, idx) {
                    final msg = ai.messages[idx];
                    final isUser = msg.sender == 'user';

                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                        decoration: BoxDecoration(
                          color: isUser ? const Color(0xFFD0FD38) : const Color(0xFF1E2232),
                          borderRadius: BorderRadius.circular(18),
                          border: isUser ? null : Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(
                            color: isUser ? Colors.black : Colors.white,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (ai.isGeneratingResponse)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00E5FF)))),
                      SizedBox(width: 10),
                      Text('Coach AI is thinking...', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12)),
                    ],
                  ),
                ),

              // Quick Prompt Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    'I only have 30 minutes today.',
                    'What should I eat post-workout?',
                    'How can I improve my bench press?',
                    'Alternatives to squats?',
                  ].map((prompt) {
                    return ActionChip(
                      label: Text(prompt, style: const TextStyle(color: Colors.white, fontSize: 11)),
                      backgroundColor: const Color(0xFF222638),
                      onPressed: () {
                        if (sub.isFeatureLocked('ai_coach_unlimited')) {
                          PaywallModal.show(context, title: 'Unlock Unlimited AI Coach', subtitle: 'Get 24/7 unlimited access to your AI Personal Trainer.');
                        } else {
                          ai.sendMessage(prompt, auth.userProfile);
                        }
                      },
                    );
                  }).toList(),
                ),
              ),

              // Chat Input Bar
              Container(
                padding: const EdgeInsets.all(12),
                color: const Color(0xFF141722),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Ask Coach AI anything...',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF1E2232),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: Color(0xFF00E5FF)),
                      onPressed: () {
                        if (sub.isFeatureLocked('ai_coach_unlimited')) {
                          PaywallModal.show(context, title: 'Unlock Unlimited AI Coach', subtitle: 'Get 24/7 unlimited access to your AI Personal Trainer.');
                        } else {
                          ai.sendMessage(_msgController.text, auth.userProfile);
                          _msgController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 2. WORKOUT WIZARD TAB
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AI Workout Generator ⚡', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text('Specify parameters and AI will compile a complete custom program directly to your library.', style: TextStyle(color: Colors.white60, fontSize: 13)),
                const SizedBox(height: 20),

                GlassCard(
                  child: Column(
                    children: [
                      _buildDropdownTile('Primary Goal', _selectedGoal, ['Build muscle', 'Lose weight', 'Improve strength', 'General fitness'], (v) => setState(() => _selectedGoal = v!)),
                      _buildDropdownTile('Days / Week', '$_selectedDays Days', ['3 Days', '4 Days', '5 Days', '6 Days'], (v) => setState(() => _selectedDays = int.parse(v!.split(' ')[0]))),
                      _buildDropdownTile('Duration', '$_selectedDuration Mins', ['30 Mins', '45 Mins', '60 Mins', '90 Mins'], (v) => setState(() => _selectedDuration = int.parse(v!.split(' ')[0]))),
                      _buildDropdownTile('Equipment', _selectedEquipment, ['Full Gym', 'Dumbbells Only', 'Bodyweight Only'], (v) => setState(() => _selectedEquipment = v!)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                CustomButton(
                  text: 'Generate Routine with AI',
                  icon: Icons.bolt,
                  onPressed: () async {
                    if (sub.isFeatureLocked('ai_workout_generator')) {
                      PaywallModal.show(context, title: 'Unlock AI Generator', subtitle: 'Generate tailored routines for any schedule and equipment.');
                    } else {
                      final generatedRoutine = await ai.generateAIWorkout(
                        goal: _selectedGoal,
                        days: _selectedDays,
                        durationMinutes: _selectedDuration,
                        equipment: _selectedEquipment,
                        level: _selectedLevel,
                      );
                      await workout.addCustomRoutine(generatedRoutine);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('AI Routine created & added to Custom Workouts! 🎉')));
                      }
                    }
                  },
                ),
              ],
            ),
          ),

          // 3. PROGRESS REPORT TAB
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AI Progress Analysis 📈', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                GlassCard(
                  borderColor: const Color(0xFF00E5FF),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('🔥 Bench Press Up +12%', style: TextStyle(color: Color(0xFFD0FD38), fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 8),
                      Text(
                        'Your strength output on compound pushing movements increased by 12% over the last 8 weeks.\n\n'
                        '• Completed 87% of scheduled workouts.\n'
                        '• Lower-body training volume decreased by 18%. Priority recommendation: Add 1 extra leg accessory set.',
                        style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile(String title, String val, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          DropdownButton<String>(
            value: items.contains(val) ? val : items.first,
            dropdownColor: const Color(0xFF1F2332),
            style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold),
            onChanged: onChanged,
            items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          ),
        ],
      ),
    );
  }
}
