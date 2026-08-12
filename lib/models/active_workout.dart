import 'workout_program.dart';

class ActiveWorkoutSession {
  final String id;
  final String routineId;
  final String routineTitle;
  final DateTime startTime;
  DateTime? endTime;
  int currentExerciseIndex;
  List<WorkoutExercise> exercises;
  bool isPaused;
  int elapsedSeconds;
  int activeRestSeconds;
  bool isRestTimerRunning;

  ActiveWorkoutSession({
    required this.id,
    required this.routineId,
    required this.routineTitle,
    required this.startTime,
    this.endTime,
    this.currentExerciseIndex = 0,
    required this.exercises,
    this.isPaused = false,
    this.elapsedSeconds = 0,
    this.activeRestSeconds = 0,
    this.isRestTimerRunning = false,
  });

  double get totalVolumeLifted {
    double sum = 0;
    for (var ex in exercises) {
      for (var s in ex.sets) {
        if (s.isCompleted) {
          sum += (s.actualWeightKg * s.actualReps);
        }
      }
    }
    return sum;
  }

  int get totalCompletedSets {
    int count = 0;
    for (var ex in exercises) {
      for (var s in ex.sets) {
        if (s.isCompleted) count++;
      }
    }
    return count;
  }

  int get estimatedCaloriesBurned {
    // Approx 7 calories per minute of weight training
    int minutes = (elapsedSeconds / 60).ceil();
    return (minutes * 7.5).round();
  }
}
