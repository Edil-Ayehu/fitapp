class WorkoutSetTarget {
  int setIndex;
  int targetReps;
  double targetWeightKg;
  int targetRestSeconds;
  bool isCompleted;
  int actualReps;
  double actualWeightKg;
  bool isPR;

  WorkoutSetTarget({
    required this.setIndex,
    required this.targetReps,
    required this.targetWeightKg,
    this.targetRestSeconds = 60,
    this.isCompleted = false,
    int? actualReps,
    double? actualWeightKg,
    this.isPR = false,
  })  : actualReps = actualReps ?? targetReps,
        actualWeightKg = actualWeightKg ?? targetWeightKg;

  Map<String, dynamic> toJson() => {
        'setIndex': setIndex,
        'targetReps': targetReps,
        'targetWeightKg': targetWeightKg,
        'targetRestSeconds': targetRestSeconds,
        'isCompleted': isCompleted,
        'actualReps': actualReps,
        'actualWeightKg': actualWeightKg,
        'isPR': isPR,
      };

  factory WorkoutSetTarget.fromJson(Map<String, dynamic> json) => WorkoutSetTarget(
        setIndex: json['setIndex'] ?? 1,
        targetReps: json['targetReps'] ?? 10,
        targetWeightKg: (json['targetWeightKg'] as num?)?.toDouble() ?? 50.0,
        targetRestSeconds: json['targetRestSeconds'] ?? 60,
        isCompleted: json['isCompleted'] ?? false,
        actualReps: json['actualReps'] ?? json['targetReps'] ?? 10,
        actualWeightKg: (json['actualWeightKg'] as num?)?.toDouble() ??
            (json['targetWeightKg'] as num?)?.toDouble() ??
            50.0,
        isPR: json['isPR'] ?? false,
      );
}

class WorkoutExercise {
  final String exerciseId;
  final String exerciseName;
  List<WorkoutSetTarget> sets;
  String notes;

  WorkoutExercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    this.notes = '',
  });

  Map<String, dynamic> toJson() => {
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'sets': sets.map((s) => s.toJson()).toList(),
        'notes': notes,
      };

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) => WorkoutExercise(
        exerciseId: json['exerciseId'],
        exerciseName: json['exerciseName'],
        sets: (json['sets'] as List? ?? [])
            .map((s) => WorkoutSetTarget.fromJson(s))
            .toList(),
        notes: json['notes'] ?? '',
      );
}

class WorkoutRoutine {
  final String id;
  String title;
  String description;
  String category; // PPL, Upper/Lower, HIIT, Strength, Beginner, Custom, AI Generated
  int estimatedDurationMinutes;
  List<WorkoutExercise> exercises;

  WorkoutRoutine({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.estimatedDurationMinutes,
    required this.exercises,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'estimatedDurationMinutes': estimatedDurationMinutes,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };

  factory WorkoutRoutine.fromJson(Map<String, dynamic> json) => WorkoutRoutine(
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? '',
        category: json['category'] ?? 'Custom',
        estimatedDurationMinutes: json['estimatedDurationMinutes'] ?? 45,
        exercises: (json['exercises'] as List? ?? [])
            .map((e) => WorkoutExercise.fromJson(e))
            .toList(),
      );

  static List<WorkoutRoutine> get sampleRoutines => [
        WorkoutRoutine(
          id: 'rt_chest_triceps',
          title: 'Monday — Chest & Triceps',
          description: 'Hypertrophy focused pushing session to maximize chest pump and tricep extension strength.',
          category: 'Push/Pull/Legs',
          estimatedDurationMinutes: 55,
          exercises: [
            WorkoutExercise(
              exerciseId: 'ex_bench_press',
              exerciseName: 'Barbell Bench Press',
              sets: [
                WorkoutSetTarget(setIndex: 1, targetReps: 8, targetWeightKg: 80, targetRestSeconds: 90),
                WorkoutSetTarget(setIndex: 2, targetReps: 8, targetWeightKg: 80, targetRestSeconds: 90),
                WorkoutSetTarget(setIndex: 3, targetReps: 8, targetWeightKg: 82.5, targetRestSeconds: 90),
                WorkoutSetTarget(setIndex: 4, targetReps: 6, targetWeightKg: 85, targetRestSeconds: 120),
              ],
            ),
            WorkoutExercise(
              exerciseId: 'ex_inc_db_press',
              exerciseName: 'Incline Dumbbell Press',
              sets: [
                WorkoutSetTarget(setIndex: 1, targetReps: 10, targetWeightKg: 28, targetRestSeconds: 60),
                WorkoutSetTarget(setIndex: 2, targetReps: 10, targetWeightKg: 28, targetRestSeconds: 60),
                WorkoutSetTarget(setIndex: 3, targetReps: 10, targetWeightKg: 30, targetRestSeconds: 60),
              ],
            ),
            WorkoutExercise(
              exerciseId: 'ex_cable_fly',
              exerciseName: 'Cable Chest Fly',
              sets: [
                WorkoutSetTarget(setIndex: 1, targetReps: 12, targetWeightKg: 15, targetRestSeconds: 45),
                WorkoutSetTarget(setIndex: 2, targetReps: 12, targetWeightKg: 15, targetRestSeconds: 45),
                WorkoutSetTarget(setIndex: 3, targetReps: 12, targetWeightKg: 17.5, targetRestSeconds: 45),
              ],
            ),
            WorkoutExercise(
              exerciseId: 'ex_tricep_pushdown',
              exerciseName: 'Cable Tricep Pushdown',
              sets: [
                WorkoutSetTarget(setIndex: 1, targetReps: 12, targetWeightKg: 35, targetRestSeconds: 45),
                WorkoutSetTarget(setIndex: 2, targetReps: 12, targetWeightKg: 35, targetRestSeconds: 45),
                WorkoutSetTarget(setIndex: 3, targetReps: 10, targetWeightKg: 40, targetRestSeconds: 45),
              ],
            ),
          ],
        ),
        WorkoutRoutine(
          id: 'rt_back_biceps',
          title: 'Tuesday — Back & Biceps',
          description: 'Heavy pull routine aimed at back width, lat density, and bicep volume.',
          category: 'Push/Pull/Legs',
          estimatedDurationMinutes: 60,
          exercises: [
            WorkoutExercise(
              exerciseId: 'ex_barbell_row',
              exerciseName: 'Barbell Bent-Over Row',
              sets: [
                WorkoutSetTarget(setIndex: 1, targetReps: 8, targetWeightKg: 70, targetRestSeconds: 90),
                WorkoutSetTarget(setIndex: 2, targetReps: 8, targetWeightKg: 70, targetRestSeconds: 90),
                WorkoutSetTarget(setIndex: 3, targetReps: 8, targetWeightKg: 75, targetRestSeconds: 90),
              ],
            ),
            WorkoutExercise(
              exerciseId: 'ex_lat_pulldown',
              exerciseName: 'Lat Pulldown',
              sets: [
                WorkoutSetTarget(setIndex: 1, targetReps: 10, targetWeightKg: 60, targetRestSeconds: 60),
                WorkoutSetTarget(setIndex: 2, targetReps: 10, targetWeightKg: 60, targetRestSeconds: 60),
                WorkoutSetTarget(setIndex: 3, targetReps: 10, targetWeightKg: 65, targetRestSeconds: 60),
              ],
            ),
            WorkoutExercise(
              exerciseId: 'ex_bicep_curl',
              exerciseName: 'Barbell Bicep Curl',
              sets: [
                WorkoutSetTarget(setIndex: 1, targetReps: 10, targetWeightKg: 30, targetRestSeconds: 45),
                WorkoutSetTarget(setIndex: 2, targetReps: 10, targetWeightKg: 30, targetRestSeconds: 45),
                WorkoutSetTarget(setIndex: 3, targetReps: 8, targetWeightKg: 32.5, targetRestSeconds: 45),
              ],
            ),
          ],
        ),
        WorkoutRoutine(
          id: 'rt_legs_abs',
          title: 'Thursday — Legs & Abs',
          description: 'Lower body blast with heavy squats, hamstring hinges, and core planks.',
          category: 'Push/Pull/Legs',
          estimatedDurationMinutes: 50,
          exercises: [
            WorkoutExercise(
              exerciseId: 'ex_barbell_squat',
              exerciseName: 'Barbell Back Squat',
              sets: [
                WorkoutSetTarget(setIndex: 1, targetReps: 8, targetWeightKg: 100, targetRestSeconds: 120),
                WorkoutSetTarget(setIndex: 2, targetReps: 8, targetWeightKg: 100, targetRestSeconds: 120),
                WorkoutSetTarget(setIndex: 3, targetReps: 6, targetWeightKg: 105, targetRestSeconds: 120),
              ],
            ),
            WorkoutExercise(
              exerciseId: 'ex_leg_press',
              exerciseName: 'Machine Leg Press',
              sets: [
                WorkoutSetTarget(setIndex: 1, targetReps: 12, targetWeightKg: 160, targetRestSeconds: 60),
                WorkoutSetTarget(setIndex: 2, targetReps: 12, targetWeightKg: 160, targetRestSeconds: 60),
                WorkoutSetTarget(setIndex: 3, targetReps: 12, targetWeightKg: 180, targetRestSeconds: 60),
              ],
            ),
            WorkoutExercise(
              exerciseId: 'ex_plank',
              exerciseName: 'Core Forearm Plank',
              sets: [
                WorkoutSetTarget(setIndex: 1, targetReps: 60, targetWeightKg: 0, targetRestSeconds: 45),
                WorkoutSetTarget(setIndex: 2, targetReps: 60, targetWeightKg: 0, targetRestSeconds: 45),
              ],
            ),
          ],
        ),
      ];
}

class WorkoutProgram {
  final String id;
  final String title;
  final String category;
  final String description;
  final String level; // Beginner, Intermediate, Advanced
  final int durationWeeks;
  final int daysPerWeek;
  final List<WorkoutRoutine> routines;

  WorkoutProgram({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.level,
    required this.durationWeeks,
    required this.daysPerWeek,
    required this.routines,
  });

  static List<WorkoutProgram> get samplePrograms => [
        WorkoutProgram(
          id: 'prog_ppl',
          title: 'Push / Pull / Legs Hypertrophy',
          category: 'Muscle Building',
          description: 'The ultimate 6-day split designed for maximal muscle hypertrophy and strength gains.',
          level: 'Intermediate',
          durationWeeks: 8,
          daysPerWeek: 6,
          routines: WorkoutRoutine.sampleRoutines,
        ),
        WorkoutProgram(
          id: 'prog_upper_lower',
          title: 'Upper / Lower Power & Size',
          category: 'Muscle Building',
          description: 'Balanced 4-day workout program targeting heavy upper body compound movements and lower body squats & hinges.',
          level: 'Intermediate',
          durationWeeks: 6,
          daysPerWeek: 4,
          routines: [WorkoutRoutine.sampleRoutines.first, WorkoutRoutine.sampleRoutines.last],
        ),
        WorkoutProgram(
          id: 'prog_hiit_fatloss',
          title: 'High Intensity Fat Burner',
          category: 'Weight Loss',
          description: 'Fast-paced high intensity circuit training aimed at maximizing calorie expenditure and cardiovascular fitness.',
          level: 'Beginner',
          durationWeeks: 4,
          daysPerWeek: 3,
          routines: [WorkoutRoutine.sampleRoutines[1]],
        ),
        WorkoutProgram(
          id: 'prog_strength_5x5',
          title: '5x5 Powerlifting Strength Progression',
          category: 'Strength',
          description: 'Classic strength builder using compound lifts to build raw power and core mass.',
          level: 'Advanced',
          durationWeeks: 12,
          daysPerWeek: 3,
          routines: WorkoutRoutine.sampleRoutines,
        ),
        WorkoutProgram(
          id: 'prog_beginner_3day',
          title: '3-Day Full Body Beginner Foundation',
          category: 'Beginner',
          description: 'Perfect starting point for newcomers to establish proper exercise form and baseline conditioning.',
          level: 'Beginner',
          durationWeeks: 4,
          daysPerWeek: 3,
          routines: [WorkoutRoutine.sampleRoutines.first],
        ),
        WorkoutProgram(
          id: 'prog_glute_sculpt',
          title: 'Glute & Lower Body Developer',
          category: 'Specialized',
          description: 'Targeted hypertrophy program focusing on glute isolation, hip thrusts, and hamstring shape.',
          level: 'Intermediate',
          durationWeeks: 8,
          daysPerWeek: 4,
          routines: [WorkoutRoutine.sampleRoutines.last],
        ),
      ];
}
