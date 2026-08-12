import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/active_workout.dart';
import '../models/workout_program.dart';
import '../models/workout_log.dart';
import 'workout_provider.dart';

class ActiveWorkoutProvider extends ChangeNotifier {
  ActiveWorkoutSession? _session;
  Timer? _workoutTimer;
  Timer? _restTimer;

  // PR alerts achieved during session
  final List<String> _sessionPRs = [];

  ActiveWorkoutSession? get session => _session;
  bool get hasActiveSession => _session != null;
  List<String> get sessionPRs => _sessionPRs;

  void startWorkout(WorkoutRoutine routine, List<PersonalRecord> existingPRs) {
    _sessionPRs.clear();
    _session = ActiveWorkoutSession(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      routineId: routine.id,
      routineTitle: routine.title,
      startTime: DateTime.now(),
      exercises: routine.exercises.map((e) {
        return WorkoutExercise(
          exerciseId: e.exerciseId,
          exerciseName: e.exerciseName,
          sets: e.sets.map((s) => WorkoutSetTarget(
            setIndex: s.setIndex,
            targetReps: s.targetReps,
            targetWeightKg: s.targetWeightKg,
            targetRestSeconds: s.targetRestSeconds,
          )).toList(),
          notes: e.notes,
        );
      }).toList(),
    );

    _startWorkoutTimer();
    notifyListeners();
  }

  void _startWorkoutTimer() {
    _workoutTimer?.cancel();
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_session != null && !_session!.isPaused) {
        _session!.elapsedSeconds++;

        if (_session!.isRestTimerRunning && _session!.activeRestSeconds > 0) {
          _session!.activeRestSeconds--;
          if (_session!.activeRestSeconds <= 0) {
            _session!.isRestTimerRunning = false;
          }
        }
        notifyListeners();
      }
    });
  }

  void changeExerciseIndex(int newIndex) {
    if (_session != null && newIndex >= 0 && newIndex < _session!.exercises.length) {
      _session!.currentExerciseIndex = newIndex;
      notifyListeners();
    }
  }

  void togglePause() {
    if (_session != null) {
      _session!.isPaused = !_session!.isPaused;
      notifyListeners();
    }
  }

  void toggleSetCompletion(int exerciseIdx, int setIdx, List<PersonalRecord> existingPRs) {
    if (_session == null) return;
    final setObj = _session!.exercises[exerciseIdx].sets[setIdx];
    setObj.isCompleted = !setObj.isCompleted;

    if (setObj.isCompleted) {
      // Check PR
      final exName = _session!.exercises[exerciseIdx].exerciseName;
      final currentMax = existingPRs
          .where((p) => p.exerciseName.toLowerCase() == exName.toLowerCase())
          .fold(0.0, (prev, p) => p.maxWeightKg > prev ? p.maxWeightKg : prev);

      if (setObj.actualWeightKg > currentMax && currentMax > 0) {
        setObj.isPR = true;
        final prText = "$exName: ${setObj.actualWeightKg}kg × ${setObj.actualReps}";
        if (!_sessionPRs.contains(prText)) {
          _sessionPRs.add(prText);
        }
      }

      // Trigger automatic Rest Timer!
      startRestTimer(setObj.targetRestSeconds);
    }

    notifyListeners();
  }

  void updateSetData(int exerciseIdx, int setIdx, {int? reps, double? weight}) {
    if (_session == null) return;
    final setObj = _session!.exercises[exerciseIdx].sets[setIdx];
    if (reps != null) setObj.actualReps = reps;
    if (weight != null) setObj.actualWeightKg = weight;
    notifyListeners();
  }

  void addSet(int exerciseIdx) {
    if (_session == null) return;
    final sets = _session!.exercises[exerciseIdx].sets;
    final lastSet = sets.isNotEmpty ? sets.last : WorkoutSetTarget(setIndex: 1, targetReps: 10, targetWeightKg: 50);
    sets.add(WorkoutSetTarget(
      setIndex: sets.length + 1,
      targetReps: lastSet.targetReps,
      targetWeightKg: lastSet.targetWeightKg,
      targetRestSeconds: lastSet.targetRestSeconds,
    ));
    notifyListeners();
  }

  void startRestTimer(int seconds) {
    if (_session == null) return;
    _session!.activeRestSeconds = seconds;
    _session!.isRestTimerRunning = true;
    notifyListeners();
  }

  void addRestTime(int extraSeconds) {
    if (_session == null) return;
    _session!.activeRestSeconds += extraSeconds;
    _session!.isRestTimerRunning = true;
    notifyListeners();
  }

  void skipRestTimer() {
    if (_session == null) return;
    _session!.activeRestSeconds = 0;
    _session!.isRestTimerRunning = false;
    notifyListeners();
  }

  Future<WorkoutLogEntry?> finishWorkout(WorkoutProvider workoutProvider) async {
    if (_session == null) return null;

    _workoutTimer?.cancel();
    _session!.endTime = DateTime.now();

    final log = WorkoutLogEntry(
      id: _session!.id,
      routineTitle: _session!.routineTitle,
      date: _session!.startTime,
      durationMinutes: (_session!.elapsedSeconds / 60).ceil(),
      totalVolumeKg: _session!.totalVolumeLifted,
      caloriesBurned: _session!.estimatedCaloriesBurned,
      exerciseCount: _session!.exercises.length,
      totalSets: _session!.totalCompletedSets,
      prsAchieved: List.from(_sessionPRs),
    );

    final newPRs = <PersonalRecord>[];
    for (var prStr in _sessionPRs) {
      newPRs.add(PersonalRecord(
        id: 'pr_${DateTime.now().millisecondsSinceEpoch}',
        exerciseId: 'ex_custom',
        exerciseName: prStr.split(':')[0],
        maxWeightKg: double.tryParse(prStr.split(':')[1].trim().split('kg')[0]) ?? 0,
        reps: 6,
        dateAchieved: DateTime.now(),
      ));
    }

    await workoutProvider.logCompletedWorkout(log, newPRs);

    _session = null;
    notifyListeners();
    return log;
  }

  void cancelWorkout() {
    _workoutTimer?.cancel();
    _session = null;
    notifyListeners();
  }
}
