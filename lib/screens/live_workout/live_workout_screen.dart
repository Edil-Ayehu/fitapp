import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/active_workout_provider.dart';
import '../../providers/workout_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/rest_timer_dialog.dart';

class LiveWorkoutScreen extends StatelessWidget {
  const LiveWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final active = Provider.of<ActiveWorkoutProvider>(context);
    final workout = Provider.of<WorkoutProvider>(context);
    final session = active.session;

    if (session == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF10121A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No active workout session', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Back to Workouts',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );
    }

    final currentExercise = session.exercises[session.currentExerciseIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141722),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => _showCancelWorkoutDialog(context, active),
        ),
        title: Column(
          children: [
            Text(session.routineTitle, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
              _formatDuration(session.elapsedSeconds),
              style: const TextStyle(color: Color(0xFFD0FD38), fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(session.isPaused ? Icons.play_arrow : Icons.pause, color: Colors.white),
            onPressed: active.togglePause,
          ),
          TextButton(
            onPressed: () async {
              final log = await active.finishWorkout(workout);
              if (log != null && context.mounted) {
                _showWorkoutSummaryDialog(context, log);
              }
            },
            child: const Text('FINISH', style: TextStyle(color: Color(0xFFD0FD38), fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PR Alerts if triggered during session
                  if (active.sessionPRs.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB800).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFFB800)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.emoji_events, color: Color(0xFFFFB800), size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('🏆 NEW PERSONAL RECORD!', style: TextStyle(color: Color(0xFFFFB800), fontWeight: FontWeight.bold, fontSize: 13)),
                                Text(active.sessionPRs.last, style: const TextStyle(color: Colors.white, fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Auto-Progression Recommendation Banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E5FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.4)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.bolt, color: Color(0xFF00E5FF), size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Recommended today: +2.5kg progressive overload over last week!',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Exercise Header & Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          currentExercise.exerciseName,
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.note_add_outlined, color: Colors.white60),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Text('Exercise ${session.currentExerciseIndex + 1} of ${session.exercises.length}', style: const TextStyle(color: Colors.white60, fontSize: 13)),
                  const SizedBox(height: 16),

                  // Set Logging Table Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: const [
                        SizedBox(width: 40, child: Text('SET', style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold))),
                        SizedBox(width: 90, child: Text('PREVIOUS', style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold))),
                        SizedBox(width: 80, child: Text('KG', style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold))),
                        SizedBox(width: 80, child: Text('REPS', style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold))),
                        Spacer(),
                        Icon(Icons.check, color: Colors.white60, size: 18),
                      ],
                    ),
                  ),

                  // Sets Rows
                  ...currentExercise.sets.asMap().entries.map((entry) {
                    final setIdx = entry.key;
                    final setObj = entry.value;

                    return GlassCard(
                      borderColor: setObj.isCompleted ? const Color(0xFFD0FD38) : null,
                      backgroundColor: setObj.isCompleted ? const Color(0xFF1D2423) : null,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                            child: Text(
                              '${setObj.setIndex}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            width: 90,
                            child: Text(
                              '80kg × 8',
                              style: TextStyle(color: Colors.white38, fontSize: 13),
                            ),
                          ),

                          // Weight Input
                          SizedBox(
                            width: 75,
                            child: TextFormField(
                              initialValue: setObj.actualWeightKg.toString(),
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              onChanged: (v) {
                                final w = double.tryParse(v);
                                if (w != null) active.updateSetData(session.currentExerciseIndex, setIdx, weight: w);
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                filled: true,
                                fillColor: const Color(0xFF141722),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Reps Input
                          SizedBox(
                            width: 75,
                            child: TextFormField(
                              initialValue: setObj.actualReps.toString(),
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              onChanged: (v) {
                                final r = int.tryParse(v);
                                if (r != null) active.updateSetData(session.currentExerciseIndex, setIdx, reps: r);
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                filled: true,
                                fillColor: const Color(0xFF141722),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Completion Checkmark Box
                          GestureDetector(
                            onTap: () => active.toggleSetCompletion(session.currentExerciseIndex, setIdx, workout.prs),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: setObj.isCompleted ? const Color(0xFFD0FD38) : const Color(0xFF222638),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.check,
                                color: setObj.isCompleted ? Colors.black : Colors.white38,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: '+ Add Set',
                          isPrimary: false,
                          onPressed: () => active.addSet(session.currentExerciseIndex),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Exercise Navigation buttons
                  Row(
                    children: [
                      if (session.currentExerciseIndex > 0)
                        Expanded(
                          child: CustomButton(
                            text: 'Previous',
                            isPrimary: false,
                            onPressed: () => active.changeExerciseIndex(session.currentExerciseIndex - 1),
                          ),
                        ),
                      if (session.currentExerciseIndex > 0) const SizedBox(width: 12),
                      if (session.currentExerciseIndex < session.exercises.length - 1)
                        Expanded(
                          child: CustomButton(
                            text: 'Next Exercise',
                            onPressed: () => active.changeExerciseIndex(session.currentExerciseIndex + 1),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Rest Timer Modal overlay
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: RestTimerDialog(),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final m = (seconds / 60).floor().toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _showCancelWorkoutDialog(BuildContext context, ActiveWorkoutProvider active) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F2332),
        title: const Text('Discard Workout?', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to cancel this workout session? Progress will not be saved.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Resume', style: TextStyle(color: Colors.white60))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              active.cancelWorkout();
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }

  void _showWorkoutSummaryDialog(BuildContext context, dynamic log) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF141722),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Center(
          child: Column(
            children: [
              Text('🎉', style: TextStyle(fontSize: 50)),
              SizedBox(height: 8),
              Text('WORKOUT COMPLETE!', style: TextStyle(color: Color(0xFFD0FD38), fontWeight: FontWeight.w900, fontSize: 20)),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(log.routineTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStat('Duration', '${log.durationMinutes} min'),
                _buildSummaryStat('Volume', '${log.totalVolumeKg.round()} kg'),
                _buildSummaryStat('Calories', '${log.caloriesBurned} kcal'),
              ],
            ),
          ],
        ),
        actions: [
          CustomButton(
            text: 'Save & View Summary',
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildSummaryStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Color(0xFFD0FD38), fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }
}
