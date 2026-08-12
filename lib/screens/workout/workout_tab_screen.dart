import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../../providers/active_workout_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/stat_chip.dart';
import '../../widgets/custom_button.dart';
import '../live_workout/live_workout_screen.dart';
import 'exercise_detail_screen.dart';
import 'custom_workout_builder_screen.dart';

class WorkoutTabScreen extends StatefulWidget {
  const WorkoutTabScreen({super.key});

  @override
  State<WorkoutTabScreen> createState() => _WorkoutTabScreenState();
}

class _WorkoutTabScreenState extends State<WorkoutTabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141722),
        elevation: 0,
        title: const Text('Workout Hub 🏋️‍♂️', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFD0FD38),
          labelColor: const Color(0xFFD0FD38),
          unselectedLabelColor: Colors.white60,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Library'),
            Tab(text: 'Programs'),
            Tab(text: 'Custom Builder'),
            Tab(text: 'History & PRs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ExerciseLibraryView(),
          _ProgramsView(),
          _CustomRoutinesView(),
          _HistoryAndPRsView(),
        ],
      ),
    );
  }
}

// 1. EXERCISE LIBRARY TAB
class _ExerciseLibraryView extends StatelessWidget {
  const _ExerciseLibraryView();

  @override
  Widget build(BuildContext context) {
    final workout = Provider.of<WorkoutProvider>(context);

    return Column(
      children: [
        // Search & Filters
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF141722),
          child: Column(
            children: [
              TextField(
                onChanged: workout.setSearchQuery,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search exercise name or muscle...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFD0FD38)),
                  filled: true,
                  fillColor: const Color(0xFF1E2232),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),

              // Muscle Filter horizontal chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'All', 'Chest', 'Back', 'Shoulders', 'Biceps', 'Triceps', 'Legs', 'Glutes', 'Abs'
                  ].map((m) {
                    final isSel = workout.selectedMuscleFilter == m;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text(m),
                        selected: isSel,
                        selectedColor: const Color(0xFFD0FD38),
                        backgroundColor: const Color(0xFF1E2232),
                        labelStyle: TextStyle(color: isSel ? Colors.black : Colors.white, fontWeight: FontWeight.w600),
                        onSelected: (_) => workout.setMuscleFilter(m),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Exercise List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: workout.filteredExercises.length,
            itemBuilder: (ctx, idx) {
              final ex = workout.filteredExercises[idx];
              return GlassCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => ExerciseDetailScreen(exercise: ex)),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF222638),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          _getMuscleEmoji(ex.primaryMuscles.first),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ex.name,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              StatChip(label: ex.primaryMuscles.first, color: const Color(0xFFD0FD38)),
                              const SizedBox(width: 6),
                              StatChip(label: ex.equipment, color: const Color(0xFF00E5FF)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getMuscleEmoji(String muscle) {
    switch (muscle) {
      case 'Chest': return '🏋️‍♂️';
      case 'Back': return '🦾';
      case 'Legs': return '🦵';
      case 'Shoulders': return '🎽';
      case 'Biceps': return '💪';
      case 'Triceps': return '⚡';
      case 'Glutes': return '🍑';
      case 'Abs': return '🔥';
      default: return '🏋️';
    }
  }
}

// 2. PROGRAMS TAB
class _ProgramsView extends StatelessWidget {
  const _ProgramsView();

  @override
  Widget build(BuildContext context) {
    final workout = Provider.of<WorkoutProvider>(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workout.allPrograms.length,
      itemBuilder: (ctx, idx) {
        final prog = workout.allPrograms[idx];
        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatChip(label: prog.category, color: const Color(0xFFD0FD38)),
                  StatChip(label: '${prog.daysPerWeek} Days/Wk', color: const Color(0xFF00E5FF)),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                prog.title,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                prog.description,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${prog.durationWeeks} Weeks • Level: ${prog.level}', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  TextButton(
                    onPressed: () {
                      final active = Provider.of<ActiveWorkoutProvider>(context, listen: false);
                      active.startWorkout(prog.routines.first, workout.prs);
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const LiveWorkoutScreen()));
                    },
                    child: const Text('Start Program', style: TextStyle(color: Color(0xFFD0FD38), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// 3. CUSTOM ROUTINES TAB
class _CustomRoutinesView extends StatelessWidget {
  const _CustomRoutinesView();

  @override
  Widget build(BuildContext context) {
    final workout = Provider.of<WorkoutProvider>(context);
    final active = Provider.of<ActiveWorkoutProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CustomButton(
            text: 'Create New Custom Workout',
            icon: Icons.add,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CustomWorkoutBuilderScreen())),
          ),
          const SizedBox(height: 16),

          ...workout.customRoutines.map((routine) {
            return GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(routine.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white70),
                        color: const Color(0xFF1F2332),
                        onSelected: (val) {
                          if (val == 'dup') workout.duplicateRoutine(routine);
                          if (val == 'del') workout.deleteRoutine(routine.id);
                        },
                        itemBuilder: (ctx) => [
                          const PopupMenuItem(value: 'dup', child: Text('Duplicate', style: TextStyle(color: Colors.white))),
                          const PopupMenuItem(value: 'del', child: Text('Delete', style: TextStyle(color: Colors.redAccent))),
                        ],
                      ),
                    ],
                  ),
                  Text('${routine.exercises.length} Exercises • ~${routine.estimatedDurationMinutes} Mins', style: const TextStyle(color: Colors.white60, fontSize: 13)),
                  const SizedBox(height: 12),

                  Column(
                    children: routine.exercises.map((ex) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.check, color: Color(0xFFD0FD38), size: 14),
                            const SizedBox(width: 8),
                            Text(ex.exerciseName, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                            const Spacer(),
                            Text('${ex.sets.length} sets', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  CustomButton(
                    text: 'Start Workout',
                    icon: Icons.play_arrow,
                    onPressed: () {
                      active.startWorkout(routine, workout.prs);
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const LiveWorkoutScreen()));
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// 4. HISTORY & PRS TAB
class _HistoryAndPRsView extends StatelessWidget {
  const _HistoryAndPRsView();

  @override
  Widget build(BuildContext context) {
    final workout = Provider.of<WorkoutProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🏆 Personal Records (PRs)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: workout.prs.map((pr) {
                return Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1E2B),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFFFB800)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.emoji_events, color: Color(0xFFFFB800), size: 28),
                      const SizedBox(height: 8),
                      Text(pr.exerciseName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('${pr.maxWeightKg} kg × ${pr.reps}', style: const TextStyle(color: Color(0xFFD0FD38), fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          const Text('📜 Completed Workout History', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          ...workout.workoutLogs.map((log) {
            return GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(log.routineTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${log.durationMinutes} min', style: const TextStyle(color: Color(0xFFD0FD38), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Volume: ${log.totalVolumeKg.round()} kg • Calories: ${log.caloriesBurned} kcal • Exercises: ${log.exerciseCount}', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                  if (log.prsAchieved.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.emoji_events, color: Color(0xFFFFB800), size: 16),
                        const SizedBox(width: 6),
                        Text(log.prsAchieved.first, style: const TextStyle(color: Color(0xFFFFB800), fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
