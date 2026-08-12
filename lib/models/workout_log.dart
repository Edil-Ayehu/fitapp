class PersonalRecord {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final double maxWeightKg;
  final int reps;
  final DateTime dateAchieved;

  PersonalRecord({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.maxWeightKg,
    required this.reps,
    required this.dateAchieved,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'maxWeightKg': maxWeightKg,
        'reps': reps,
        'dateAchieved': dateAchieved.toIso8601String(),
      };

  factory PersonalRecord.fromJson(Map<String, dynamic> json) => PersonalRecord(
        id: json['id'],
        exerciseId: json['exerciseId'],
        exerciseName: json['exerciseName'],
        maxWeightKg: (json['maxWeightKg'] as num).toDouble(),
        reps: json['reps'],
        dateAchieved: DateTime.parse(json['dateAchieved']),
      );
}

class WorkoutLogEntry {
  final String id;
  final String routineTitle;
  final DateTime date;
  final int durationMinutes;
  final double totalVolumeKg;
  final int caloriesBurned;
  final int exerciseCount;
  final int totalSets;
  final List<String> prsAchieved; // e.g. ["Bench Press 85kg x 6"]

  WorkoutLogEntry({
    required this.id,
    required this.routineTitle,
    required this.date,
    required this.durationMinutes,
    required this.totalVolumeKg,
    required this.caloriesBurned,
    required this.exerciseCount,
    required this.totalSets,
    this.prsAchieved = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'routineTitle': routineTitle,
        'date': date.toIso8601String(),
        'durationMinutes': durationMinutes,
        'totalVolumeKg': totalVolumeKg,
        'caloriesBurned': caloriesBurned,
        'exerciseCount': exerciseCount,
        'totalSets': totalSets,
        'prsAchieved': prsAchieved,
      };

  factory WorkoutLogEntry.fromJson(Map<String, dynamic> json) => WorkoutLogEntry(
        id: json['id'],
        routineTitle: json['routineTitle'],
        date: DateTime.parse(json['date']),
        durationMinutes: json['durationMinutes'],
        totalVolumeKg: (json['totalVolumeKg'] as num).toDouble(),
        caloriesBurned: json['caloriesBurned'],
        exerciseCount: json['exerciseCount'],
        totalSets: json['totalSets'],
        prsAchieved: List<String>.from(json['prsAchieved'] ?? []),
      );

  static List<WorkoutLogEntry> get sampleLogs => [
        WorkoutLogEntry(
          id: 'log_1',
          routineTitle: 'Chest & Triceps Hypertrophy',
          date: DateTime.now().subtract(const Duration(days: 1)),
          durationMinutes: 54,
          totalVolumeKg: 8450,
          caloriesBurned: 420,
          exerciseCount: 4,
          totalSets: 13,
          prsAchieved: ['Bench Press: 85kg × 6 reps'],
        ),
        WorkoutLogEntry(
          id: 'log_2',
          routineTitle: 'Back & Biceps Thickness',
          date: DateTime.now().subtract(const Duration(days: 3)),
          durationMinutes: 58,
          totalVolumeKg: 9100,
          caloriesBurned: 460,
          exerciseCount: 4,
          totalSets: 12,
          prsAchieved: [],
        ),
        WorkoutLogEntry(
          id: 'log_3',
          routineTitle: 'Legs & Abs Power',
          date: DateTime.now().subtract(const Duration(days: 5)),
          durationMinutes: 62,
          totalVolumeKg: 11200,
          caloriesBurned: 510,
          exerciseCount: 3,
          totalSets: 10,
          prsAchieved: ['Barbell Squat: 105kg × 6 reps'],
        ),
      ];
}
