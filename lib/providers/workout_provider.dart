import 'package:flutter/foundation.dart';
import '../models/exercise.dart';
import '../models/workout_program.dart';
import '../models/workout_log.dart';
import '../services/storage_service.dart';

class WorkoutProvider extends ChangeNotifier {
  final StorageService _storageService;

  List<Exercise> _allExercises = [];
  List<WorkoutProgram> _allPrograms = [];
  List<WorkoutRoutine> _customRoutines = [];
  List<WorkoutLogEntry> _workoutLogs = [];
  List<PersonalRecord> _prs = [];

  String _searchQuery = '';
  String _selectedMuscleFilter = 'All';
  String _selectedEquipmentFilter = 'All';
  String _selectedDifficultyFilter = 'All';

  WorkoutProvider(this._storageService) {
    _allExercises = Exercise.sampleExercises;
    _allPrograms = WorkoutProgram.samplePrograms;
    _customRoutines = _storageService.getCustomRoutines();
    _workoutLogs = _storageService.getWorkoutLogs();
    _prs = _storageService.getPRs();
  }

  List<Exercise> get allExercises => _allExercises;
  List<WorkoutProgram> get allPrograms => _allPrograms;
  List<WorkoutRoutine> get customRoutines => _customRoutines;
  List<WorkoutLogEntry> get workoutLogs => _workoutLogs;
  List<PersonalRecord> get prs => _prs;

  String get searchQuery => _searchQuery;
  String get selectedMuscleFilter => _selectedMuscleFilter;
  String get selectedEquipmentFilter => _selectedEquipmentFilter;
  String get selectedDifficultyFilter => _selectedDifficultyFilter;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setMuscleFilter(String muscle) {
    _selectedMuscleFilter = muscle;
    notifyListeners();
  }

  void setEquipmentFilter(String equipment) {
    _selectedEquipmentFilter = equipment;
    notifyListeners();
  }

  void setDifficultyFilter(String diff) {
    _selectedDifficultyFilter = diff;
    notifyListeners();
  }

  List<Exercise> get filteredExercises {
    return _allExercises.where((ex) {
      final matchesSearch = _searchQuery.isEmpty ||
          ex.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ex.primaryMuscles.any((m) => m.toLowerCase().contains(_searchQuery.toLowerCase()));

      final matchesMuscle = _selectedMuscleFilter == 'All' ||
          ex.primaryMuscles.contains(_selectedMuscleFilter) ||
          ex.secondaryMuscles.contains(_selectedMuscleFilter);

      final matchesEquipment = _selectedEquipmentFilter == 'All' ||
          ex.equipment == _selectedEquipmentFilter;

      final matchesDifficulty = _selectedDifficultyFilter == 'All' ||
          ex.difficulty == _selectedDifficultyFilter;

      return matchesSearch && matchesMuscle && matchesEquipment && matchesDifficulty;
    }).toList();
  }

  Future<void> addCustomRoutine(WorkoutRoutine routine) async {
    _customRoutines.insert(0, routine);
    await _storageService.saveCustomRoutines(_customRoutines);
    notifyListeners();
  }

  Future<void> updateCustomRoutine(WorkoutRoutine routine) async {
    final idx = _customRoutines.indexWhere((r) => r.id == routine.id);
    if (idx != -1) {
      _customRoutines[idx] = routine;
      await _storageService.saveCustomRoutines(_customRoutines);
      notifyListeners();
    }
  }

  Future<void> duplicateRoutine(WorkoutRoutine routine) async {
    final dup = WorkoutRoutine(
      id: 'rt_${DateTime.now().millisecondsSinceEpoch}',
      title: '${routine.title} (Copy)',
      description: routine.description,
      category: routine.category,
      estimatedDurationMinutes: routine.estimatedDurationMinutes,
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
    await addCustomRoutine(dup);
  }

  Future<void> deleteRoutine(String id) async {
    _customRoutines.removeWhere((r) => r.id == id);
    await _storageService.saveCustomRoutines(_customRoutines);
    notifyListeners();
  }

  Future<void> logCompletedWorkout(WorkoutLogEntry log, List<PersonalRecord> newPRs) async {
    _workoutLogs.insert(0, log);
    await _storageService.saveWorkoutLogs(_workoutLogs);

    if (newPRs.isNotEmpty) {
      _prs.insertAll(0, newPRs);
      await _storageService.savePRs(_prs);
    }
    notifyListeners();
  }
}
