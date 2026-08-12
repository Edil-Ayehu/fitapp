import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/glass_card.dart';
import '../dashboard/home_dashboard_screen.dart';

class OnboardingQuizScreen extends StatelessWidget {
  const OnboardingQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: const _OnboardingBody(),
    );
  }
}

class _OnboardingBody extends StatelessWidget {
  const _OnboardingBody();

  @override
  Widget build(BuildContext context) {
    final onboarding = Provider.of<OnboardingProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header progress bar
              Row(
                children: [
                  if (onboarding.currentStep > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                      onPressed: onboarding.previousStep,
                    ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (onboarding.currentStep + 1) / onboarding.totalSteps,
                        backgroundColor: const Color(0xFF222533),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD0FD38)),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${onboarding.currentStep + 1}/${onboarding.totalSteps}',
                    style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Step Content
              Expanded(
                child: SingleChildScrollView(
                  child: _buildStepContent(context, onboarding),
                ),
              ),

              // Navigation button
              CustomButton(
                text: onboarding.currentStep == onboarding.totalSteps - 1 ? 'Generate My Plan ⚡' : 'Continue',
                onPressed: () async {
                  if (onboarding.currentStep < onboarding.totalSteps - 1) {
                    onboarding.nextStep();
                  } else {
                    final profile = onboarding.generateFinalProfile(auth.userProfile.email);
                    await auth.updateProfile(profile);
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (ctx) => const HomeDashboardScreen()),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, OnboardingProvider onboarding) {
    switch (onboarding.currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personal Info 👤', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Tell us a little bit about yourself to personalize your plan.', style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 24),
            TextField(
              controller: TextEditingController(text: onboarding.name)..selection = TextSelection.collapsed(offset: onboarding.name.length),
              style: const TextStyle(color: Colors.white),
              onChanged: (v) => onboarding.name = v,
              decoration: InputDecoration(
                labelText: 'Your Name',
                labelStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: const Color(0xFF1B1E2B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Gender', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Row(
              children: ['Male', 'Female', 'Other'].map((g) {
                final isSel = onboarding.gender == g;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onboarding.gender = g;
                      onboarding.setStep(0);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFFD0FD38) : const Color(0xFF1B1E2B),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        g,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSel ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Body Metrics 📐', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('We calculate your precise BMR & TDEE macro targets.', style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 24),
            _buildSliderTile('Height', '${onboarding.heightCm.round()} cm', onboarding.heightCm, 140, 220, (v) {
              onboarding.heightCm = v;
              onboarding.setStep(1);
            }),
            _buildSliderTile('Current Weight', '${onboarding.weightKg.toStringAsFixed(1)} kg', onboarding.weightKg, 40, 150, (v) {
              onboarding.weightKg = v;
              onboarding.setStep(1);
            }),
            _buildSliderTile('Target Weight', '${onboarding.targetWeightKg.toStringAsFixed(1)} kg', onboarding.targetWeightKg, 40, 150, (v) {
              onboarding.targetWeightKg = v;
              onboarding.setStep(1);
            }),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Primary Goal 🎯', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('What do you want to achieve with FitPulse?', style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 20),
            ...[
              'Build muscle',
              'Lose weight',
              'Improve strength',
              'Gain weight',
              'Improve endurance',
              'General fitness'
            ].map((goal) {
              final isSel = onboarding.primaryGoal == goal;
              return GlassCard(
                onTap: () {
                  onboarding.primaryGoal = goal;
                  onboarding.setStep(2);
                },
                borderColor: isSel ? const Color(0xFFD0FD38) : null,
                child: Row(
                  children: [
                    Icon(
                      isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: isSel ? const Color(0xFFD0FD38) : Colors.white38,
                    ),
                    const SizedBox(width: 14),
                    Text(goal, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }),
          ],
        );

      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Training Experience 🏋️', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Select your experience level and preferred days per week.', style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 24),
            Row(
              children: ['Beginner', 'Intermediate', 'Advanced'].map((lvl) {
                final isSel = onboarding.fitnessLevel == lvl;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onboarding.fitnessLevel = lvl;
                      onboarding.setStep(3);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFFD0FD38) : const Color(0xFF1B1E2B),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        lvl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSel ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _buildSliderTile('Available Training Days / Week', '${onboarding.availableDays} Days', onboarding.availableDays.toDouble(), 2, 7, (v) {
              onboarding.availableDays = v.round();
              onboarding.setStep(3);
            }),
            _buildSliderTile('Session Duration', '${onboarding.workoutDurationMinutes} Mins', onboarding.workoutDurationMinutes.toDouble(), 30, 90, (v) {
              onboarding.workoutDurationMinutes = v.round();
              onboarding.setStep(3);
            }),
          ],
        );

      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Location & Equipment 📍', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Where do you train and what gear is accessible?', style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 24),
            Row(
              children: ['Gym', 'Home', 'Outdoor'].map((loc) {
                final isSel = onboarding.preferredLocation == loc;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onboarding.preferredLocation = loc;
                      onboarding.setStep(4);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFF00E5FF) : const Color(0xFF1B1E2B),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        loc,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSel ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text('Available Equipment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Barbell', 'Dumbbell', 'Machine', 'Cable', 'Kettlebell', 'Resistance band', 'Bodyweight'].map((eq) {
                final isSel = onboarding.selectedEquipment.contains(eq);
                return FilterChip(
                  label: Text(eq),
                  selected: isSel,
                  selectedColor: const Color(0xFFD0FD38),
                  backgroundColor: const Color(0xFF1B1E2B),
                  labelStyle: TextStyle(color: isSel ? Colors.black : Colors.white),
                  onSelected: (val) {
                    if (val) {
                      onboarding.selectedEquipment.add(eq);
                    } else {
                      onboarding.selectedEquipment.remove(eq);
                    }
                    onboarding.setStep(4);
                  },
                );
              }).toList(),
            ),
          ],
        );

      case 5:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Diet & Nutrition 🥗', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Set up your meal macros and dietary preferences.', style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 24),
            ...['High Protein', 'Keto', 'Vegetarian', 'Vegan', 'Balanced'].map((diet) {
              final isSel = onboarding.dietaryPreferences == diet;
              return GlassCard(
                onTap: () {
                  onboarding.dietaryPreferences = diet;
                  onboarding.setStep(5);
                },
                borderColor: isSel ? const Color(0xFFD0FD38) : null,
                child: Row(
                  children: [
                    Icon(
                      isSel ? Icons.check_circle : Icons.circle_outlined,
                      color: isSel ? const Color(0xFFD0FD38) : Colors.white38,
                    ),
                    const SizedBox(width: 14),
                    Text(diet, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }),
          ],
        );

      case 6:
      default:
        // Compiled Plan Preview
        final tempProfile = onboarding.generateFinalProfile('alex@fitpulse.app');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Plan is Ready! 🎉', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Here is your custom AI fitness algorithm breakdown:', style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 24),

            GlassCard(
              borderColor: const Color(0xFFD0FD38),
              child: Column(
                children: [
                  const Icon(Icons.stars, color: Color(0xFFD0FD38), size: 40),
                  const SizedBox(height: 8),
                  Text(
                    'Program: ${onboarding.availableDays}-Day ${onboarding.workoutStyle} Split',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricSummary('Daily Calories', '${tempProfile.targetCalories} kcal'),
                      _buildMetricSummary('Protein', '${tempProfile.targetProteinGrams}g'),
                      _buildMetricSummary('Water Goal', '${tempProfile.targetWaterLiters}L'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🚀 What happens next?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('• 4 pre-loaded routines added to your Workout Tab', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const Text('• Home Dashboard command center configured', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const Text('• AI Coach pre-loaded with your body metrics', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
          ],
        );
    }
  }

  Widget _buildSliderTile(String title, String valText, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            Text(valText, style: const TextStyle(color: Color(0xFFD0FD38), fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          activeColor: const Color(0xFFD0FD38),
          inactiveColor: const Color(0xFF25293A),
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildMetricSummary(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Color(0xFFD0FD38), fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }
}
