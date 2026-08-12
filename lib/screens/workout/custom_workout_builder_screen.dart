import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../../models/workout_program.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/glass_card.dart';

class CustomWorkoutBuilderScreen extends StatefulWidget {
  final WorkoutRoutine? editRoutine;

  const CustomWorkoutBuilderScreen({super.key, this.editRoutine});

  @override
  State<CustomWorkoutBuilderScreen> createState() => _CustomWorkoutBuilderScreenState();
}

class _CustomWorkoutBuilderScreenState extends State<CustomWorkoutBuilderScreen> {
  late TextEditingController _titleController;
  late List<WorkoutExercise> _selectedExercises;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.editRoutine?.title ?? 'My Custom Routine');
    _selectedExercises = widget.editRoutine != null
        ? List.from(widget.editRoutine!.exercises)
        : [
            WorkoutExercise(
              exerciseId: 'ex_bench_press',
              exerciseName: 'Barbell Bench Press',
              sets: [
                WorkoutSetTarget(setIndex: 1, targetReps: 10, targetWeightKg: 70),
                WorkoutSetTarget(setIndex: 2, targetReps: 10, targetWeightKg: 70),
                WorkoutSetTarget(setIndex: 3, targetReps: 8, targetWeightKg: 75),
              ],
            ),
          ];
  }

  @override
  Widget build(BuildContext context) {
    final workout = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Routine Builder ✏️', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _saveRoutine,
            child: const Text('SAVE', style: TextStyle(color: Color(0xFFD0FD38), fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Routine Title Input
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Routine Name',
                labelStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: const Color(0xFF1B1E2B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Exercises', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () => _showAddExerciseDialog(context, workout),
                  icon: const Icon(Icons.add, color: Color(0xFFD0FD38)),
                  label: const Text('Add Exercise', style: TextStyle(color: Color(0xFFD0FD38), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Exercise List inside Builder
            ..._selectedExercises.asMap().entries.map((entry) {
              final idx = entry.key;
              final ex = entry.value;

              return GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ex.exerciseName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                          onPressed: () => setState(() => _selectedExercises.removeAt(idx)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Sets table
                    ...ex.sets.map((setObj) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Text('Set ${setObj.setIndex}:', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                            const SizedBox(width: 12),
                            Text('${setObj.targetWeightKg} kg × ${setObj.targetReps} reps', style: const TextStyle(color: Color(0xFFD0FD38), fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Text('${setObj.targetRestSeconds}s rest', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                          ],
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          ex.sets.add(WorkoutSetTarget(
                            setIndex: ex.sets.length + 1,
                            targetReps: 10,
                            targetWeightKg: ex.sets.isNotEmpty ? ex.sets.last.targetWeightKg : 50,
                          ));
                        });
                      },
                      icon: const Icon(Icons.add, color: Color(0xFF00E5FF), size: 16),
                      label: const Text('Add Set', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 24),
            CustomButton(
              text: 'Save Custom Routine',
              onPressed: _saveRoutine,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddExerciseDialog(BuildContext context, WorkoutProvider workout) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F2332),
        title: const Text('Select Exercise', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: workout.allExercises.length,
            itemBuilder: (ctx, idx) {
              final ex = workout.allExercises[idx];
              return ListTile(
                title: Text(ex.name, style: const TextStyle(color: Colors.white, fontSize: 14)),
                subtitle: Text('${ex.primaryMuscles.first} • ${ex.equipment}', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                onTap: () {
                  setState(() {
                    _selectedExercises.add(WorkoutExercise(
                      exerciseId: ex.id,
                      exerciseName: ex.name,
                      sets: [
                        WorkoutSetTarget(setIndex: 1, targetReps: 10, targetWeightKg: 50),
                        WorkoutSetTarget(setIndex: 2, targetReps: 10, targetWeightKg: 50),
                        WorkoutSetTarget(setIndex: 3, targetReps: 8, targetWeightKg: 55),
                      ],
                    ));
                  });
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _saveRoutine() {
    if (_titleController.text.isEmpty || _selectedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a routine title and add at least 1 exercise.')));
      return;
    }

    final newRoutine = WorkoutRoutine(
      id: widget.editRoutine?.id ?? 'rt_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text,
      description: 'Custom created routine',
      category: 'Custom',
      estimatedDurationMinutes: 45,
      exercises: _selectedExercises,
    );

    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    if (widget.editRoutine != null) {
      workoutProvider.updateCustomRoutine(newRoutine);
    } else {
      workoutProvider.addCustomRoutine(newRoutine);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Custom routine saved successfully! 🎉')));
  }
}
