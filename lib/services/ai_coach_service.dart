import '../models/user_profile.dart';
import '../models/workout_program.dart';

class AICoachChatMessage {
  final String id;
  final String sender; // 'user' or 'ai'
  final String text;
  final DateTime timestamp;
  final String? actionType; // 'workout_modified', 'routine_created', 'plan_suggested'

  AICoachChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    DateTime? timestamp,
    this.actionType,
  }) : timestamp = timestamp ?? DateTime.now();
}

class AICoachService {
  Future<String> getAIResponse(String userPrompt, UserProfile user) async {
    await Future.delayed(const Duration(milliseconds: 900)); // Simulate thinking latency

    final promptLower = userPrompt.toLowerCase();

    if (promptLower.contains('30 min') || promptLower.contains('30-minute') || promptLower.contains('short on time')) {
      return "⚡ I've modified today's workout to fit a high-efficiency 30-minute superset routine!\n\n"
          "1. Barbell Bench Press — 3 sets × 8 reps (Rest 60s)\n"
          "2. Incline Dumbbell Press — 3 sets × 10 reps (Rest 45s)\n"
          "3. Superset: Cable Flyes + Tricep Pushdowns — 3 sets × 12 reps\n\n"
          "This maintains mechanical tension while cutting duration by 45%. You're good to go!";
    }

    if (promptLower.contains('eat') || promptLower.contains('food') || promptLower.contains('meal') || promptLower.contains('protein')) {
      return "🥗 Based on your primary goal of **${user.primaryGoal}** and target of **${user.targetCalories} kcal**:\n\n"
          "• Post-Workout Recommendation: 200g Grilled Chicken + 150g Jasmine Rice + 10g Olive Oil (approx 45g Protein / 42g Carbs / 12g Fat).\n"
          "• Quick Protein Snack: 1 scoop Whey Protein Isolate with 150g Greek Yogurt & berries.";
    }

    if (promptLower.contains('bench press') || promptLower.contains('improve bench') || promptLower.contains('stall')) {
      return "🏋️ To break through your Bench Press plateau:\n\n"
          "1. **Incorporate Pause Reps**: Hold the bar 2 seconds on your chest to eliminate stretch reflex momentum.\n"
          "2. **Strengthen Triceps**: Heavy weighted dips or close-grip bench press will boost your lockout power.\n"
          "3. **Leg Drive**: Keep feet flat and plant heels firmly into the ground to transfer force through your hips.";
    }

    if (promptLower.contains('replace squat') || promptLower.contains('alternative')) {
      return "🔄 Great alternatives for Barbell Back Squats:\n\n"
          "1. **Machine Leg Press**: Heavy quad drive with lumbar support.\n"
          "2. **Bulgarian Split Squats**: Superior unilateral stability and glute focus.\n"
          "3. **Hack Squat Machine**: Deep knee flexion with minimal lower back shear stress.";
    }

    if (promptLower.contains('how many calories') || promptLower.contains('target')) {
      return "📊 Your personalized target is **${user.targetCalories} kcal/day**:\n\n"
          "• Protein: ${user.targetProteinGrams}g (${(user.targetProteinGrams * 4 / user.targetCalories * 100).round()}%)\n"
          "• Carbs: ${user.targetCarbsGrams}g\n"
          "• Fats: ${user.targetFatGrams}g\n"
          "• Water Target: ${user.targetWaterLiters}L/day";
    }

    return "🤖 Coach FitPulse here!\n\n"
        "To achieve your goal of **${user.primaryGoal}**, maintain strict consistency across your ${user.availableDays} training days per week. "
        "Remember to progressive overload by adding 1.25kg - 2.5kg or 1 extra rep each week!";
  }

  Future<WorkoutRoutine> generateAIWorkout({
    required String goal,
    required int days,
    required int durationMinutes,
    required String equipment,
    required String level,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    return WorkoutRoutine(
      id: 'ai_rt_${DateTime.now().millisecondsSinceEpoch}',
      title: '🤖 AI Custom: $goal ($days Days/Wk)',
      description: 'Precision AI-generated routine designed for $level level with $equipment equipment ($durationMinutes mins).',
      category: 'AI Generated',
      estimatedDurationMinutes: durationMinutes,
      exercises: [
        WorkoutExercise(
          exerciseId: 'ex_bench_press',
          exerciseName: 'Barbell Bench Press',
          sets: [
            WorkoutSetTarget(setIndex: 1, targetReps: 8, targetWeightKg: 80, targetRestSeconds: 90),
            WorkoutSetTarget(setIndex: 2, targetReps: 8, targetWeightKg: 82.5, targetRestSeconds: 90),
            WorkoutSetTarget(setIndex: 3, targetReps: 6, targetWeightKg: 85, targetRestSeconds: 120),
          ],
        ),
        WorkoutExercise(
          exerciseId: 'ex_lat_pulldown',
          exerciseName: 'Lat Pulldown',
          sets: [
            WorkoutSetTarget(setIndex: 1, targetReps: 10, targetWeightKg: 60, targetRestSeconds: 60),
            WorkoutSetTarget(setIndex: 2, targetReps: 10, targetWeightKg: 65, targetRestSeconds: 60),
          ],
        ),
        WorkoutExercise(
          exerciseId: 'ex_barbell_squat',
          exerciseName: 'Barbell Back Squat',
          sets: [
            WorkoutSetTarget(setIndex: 1, targetReps: 8, targetWeightKg: 100, targetRestSeconds: 120),
            WorkoutSetTarget(setIndex: 2, targetReps: 8, targetWeightKg: 100, targetRestSeconds: 120),
          ],
        ),
      ],
    );
  }

  String generateProgressAnalysisReport({required double weightChange, required int completedWorkoutsCount}) {
    return "📈 **AI Monthly Performance Analysis**\n\n"
        "• **Strength Trends**: Your Bench Press maximum weight increased **+12%** over the last 4 weeks.\n"
        "• **Training Volume**: Total weekly volume reached **28,750 kg** (Up 6.4%).\n"
        "• **Consistency**: You completed **$completedWorkoutsCount scheduled workouts** (87% target execution).\n"
        "• **Recovery & Focus**: Lower body volume was 18% lower than upper body. Consider prioritizing leg hyper-growth next week!";
  }
}
