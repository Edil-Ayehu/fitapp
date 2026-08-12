class Exercise {
  final String id;
  final String name;
  final String description;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final String equipment; // Barbell, Dumbbell, Machine, Cable, Kettlebell, Resistance band, Bodyweight
  final String difficulty; // Beginner, Intermediate, Advanced
  final List<String> instructions;
  final List<String> commonMistakes;
  final List<String> safetyTips;
  final List<String> alternativeExerciseIds;
  final String imageUrl;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.primaryMuscles,
    this.secondaryMuscles = const [],
    required this.equipment,
    required this.difficulty,
    required this.instructions,
    this.commonMistakes = const [],
    this.safetyTips = const [],
    this.alternativeExerciseIds = const [],
    this.imageUrl = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'primaryMuscles': primaryMuscles,
        'secondaryMuscles': secondaryMuscles,
        'equipment': equipment,
        'difficulty': difficulty,
        'instructions': instructions,
        'commonMistakes': commonMistakes,
        'safetyTips': safetyTips,
        'alternativeExerciseIds': alternativeExerciseIds,
        'imageUrl': imageUrl,
      };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        primaryMuscles: List<String>.from(json['primaryMuscles'] ?? []),
        secondaryMuscles: List<String>.from(json['secondaryMuscles'] ?? []),
        equipment: json['equipment'],
        difficulty: json['difficulty'],
        instructions: List<String>.from(json['instructions'] ?? []),
        commonMistakes: List<String>.from(json['commonMistakes'] ?? []),
        safetyTips: List<String>.from(json['safetyTips'] ?? []),
        alternativeExerciseIds: List<String>.from(json['alternativeExerciseIds'] ?? []),
        imageUrl: json['imageUrl'] ?? '',
      );

  // Pre-seeded exercise library with over 25 comprehensive exercises across all body parts
  static List<Exercise> get sampleExercises => [
        // CHEST
        Exercise(
          id: 'ex_bench_press',
          name: 'Barbell Bench Press',
          description: 'The standard compound movement for developing upper body pushing strength and chest mass.',
          primaryMuscles: ['Chest'],
          secondaryMuscles: ['Triceps', 'Shoulders'],
          equipment: 'Barbell',
          difficulty: 'Intermediate',
          instructions: [
            'Lie flat on the bench, feet firmly planted on the floor.',
            'Grip the bar slightly wider than shoulder-width with eyes directly under the bar.',
            'Unrack the bar and lower it smoothly to mid-chest level while keeping elbows at a 45-degree angle.',
            'Press the bar back up explosively until arms are fully extended.'
          ],
          commonMistakes: [
            'Flaring elbows out to 90 degrees.',
            'Bouncing the bar off the chest.',
            'Lifting hips off the bench.'
          ],
          safetyTips: [
            'Always use a spotter or safety pins when lifting heavy.',
            'Maintain wrist extension alignment without excessive bend.'
          ],
          alternativeExerciseIds: ['ex_inc_db_press', 'ex_chest_fly'],
        ),
        Exercise(
          id: 'ex_inc_db_press',
          name: 'Incline Dumbbell Press',
          description: 'Target upper chest fiber activation and improve muscle symmetry.',
          primaryMuscles: ['Chest'],
          secondaryMuscles: ['Shoulders', 'Triceps'],
          equipment: 'Dumbbell',
          difficulty: 'Intermediate',
          instructions: [
            'Set an incline bench at approximately 30 degrees.',
            'Sit with a dumbbell resting on each thigh.',
            'Kick dumbbells up to shoulder position and lie back.',
            'Press dumbbells upward until arms are straight, then lower under control.'
          ],
          commonMistakes: ['Setting bench angle too steep (over 45 degrees targets shoulders).', 'Not going through full range of motion.'],
          safetyTips: ['Control the dumbbells carefully during lower and press phases.'],
          alternativeExerciseIds: ['ex_bench_press', 'ex_cable_fly'],
        ),
        Exercise(
          id: 'ex_cable_fly',
          name: 'Cable Chest Fly',
          description: 'Isolation chest exercise providing continuous mechanical tension throughout the movement.',
          primaryMuscles: ['Chest'],
          secondaryMuscles: ['Shoulders'],
          equipment: 'Cable',
          difficulty: 'Beginner',
          instructions: [
            'Set pulleys at chest height, grab handles and step forward.',
            'Keep elbows slightly bent and bring hands together in a wide hugging arc.',
            'Squeeze chest at peak contraction, then slowly open arms back up.'
          ],
          commonMistakes: ['Bending elbows too much turning it into a press.', 'Using momentum instead of controlled chest contraction.'],
          safetyTips: ['Do not overstretch shoulder joint at the start position.'],
          alternativeExerciseIds: ['ex_bench_press'],
        ),

        // BACK
        Exercise(
          id: 'ex_barbell_row',
          name: 'Barbell Bent-Over Row',
          description: 'Essential back compound builder for lat thickness and rear deltoid strength.',
          primaryMuscles: ['Back'],
          secondaryMuscles: ['Biceps', 'Shoulders'],
          equipment: 'Barbell',
          difficulty: 'Intermediate',
          instructions: [
            'Hinge at hips with knees slightly bent and spine flat at 45 degrees.',
            'Grip barbell overhand slightly wider than shoulder width.',
            'Pull bar to lower sternum/belly button, driving elbows backward.',
            'Lower weight slowly back to arm extension.'
          ],
          commonMistakes: ['Rounding lower back.', 'Using hips to bounce weight up.'],
          safetyTips: ['Engage core tight throughout the entire movement.'],
          alternativeExerciseIds: ['ex_lat_pulldown', 'ex_seated_row'],
        ),
        Exercise(
          id: 'ex_lat_pulldown',
          name: 'Lat Pulldown',
          description: 'Vertical pull exercise focusing on latissimus dorsi width.',
          primaryMuscles: ['Back'],
          secondaryMuscles: ['Biceps'],
          equipment: 'Cable',
          difficulty: 'Beginner',
          instructions: [
            'Sit at lat pulldown station with thighs secured under pads.',
            'Grip bar wider than shoulder-width with overhand grip.',
            'Lean slightly back and pull bar down to upper chest level.',
            'Slowly release bar up until lats are stretched.'
          ],
          commonMistakes: ['Pulling bar behind the neck.', 'Swinging torso backward excessively.'],
          safetyTips: ['Focus on pulling with elbows rather than hands.'],
          alternativeExerciseIds: ['ex_pullup'],
        ),
        Exercise(
          id: 'ex_pullup',
          name: 'Bodyweight Pull-Up',
          description: 'Gold standard bodyweight exercise for back width and arm strength.',
          primaryMuscles: ['Back'],
          secondaryMuscles: ['Biceps', 'Abs'],
          equipment: 'Bodyweight',
          difficulty: 'Intermediate',
          instructions: [
            'Hang from pull-up bar with overhand grip slightly wider than shoulders.',
            'Depress shoulder blades and pull body up until chin clears the bar.',
            'Lower body down with control to a full arm hang.'
          ],
          commonMistakes: ['Kipping or swinging legs.', 'Partial range of motion.'],
          safetyTips: ['Do not drop down abruptly.'],
          alternativeExerciseIds: ['ex_lat_pulldown'],
        ),

        // LEGS & GLUTES
        Exercise(
          id: 'ex_barbell_squat',
          name: 'Barbell Back Squat',
          description: 'King of lower body exercises targeting quads, glutes, and core.',
          primaryMuscles: ['Legs'],
          secondaryMuscles: ['Glutes', 'Abs'],
          equipment: 'Barbell',
          difficulty: 'Advanced',
          instructions: [
            'Position barbell across upper traps and unrack.',
            'Stand with feet shoulder-width apart, toes pointed slightly outward.',
            'Flex hips and knees to lower hips down until thighs are parallel to ground.',
            'Drive through heels back to standing position.'
          ],
          commonMistakes: ['Knees caving inward.', 'Heels coming off the ground.', 'Curving lower spine.'],
          safetyTips: ['Use safety arms in squat rack and maintain braced core.'],
          alternativeExerciseIds: ['ex_leg_press', 'ex_romanian_deadlift'],
        ),
        Exercise(
          id: 'ex_leg_press',
          name: 'Machine Leg Press',
          description: 'High volume quad and glute builder with stabilized lumbar support.',
          primaryMuscles: ['Legs'],
          secondaryMuscles: ['Glutes'],
          equipment: 'Machine',
          difficulty: 'Beginner',
          instructions: [
            'Sit in machine with back flat against pad, feet shoulder-width on sled.',
            'Unlatch safety catch and lower sled toward chest until knees reach 90 degrees.',
            'Press platform back up without locking out knees.'
          ],
          commonMistakes: ['Locking knees out at top.', 'Lifting lower back off the pad.'],
          safetyTips: ['Keep safety levers ready at all times.'],
          alternativeExerciseIds: ['ex_barbell_squat'],
        ),
        Exercise(
          id: 'ex_romanian_deadlift',
          name: 'Romanian Deadlift (RDL)',
          description: 'Posterior chain builder for hamstring strength and glute development.',
          primaryMuscles: ['Legs', 'Glutes'],
          secondaryMuscles: ['Back'],
          equipment: 'Barbell',
          difficulty: 'Intermediate',
          instructions: [
            'Stand tall holding barbell at thigh height.',
            'Keep knees soft with slight bend and hinge at hips, pushing glutes backward.',
            'Lower bar along shins until stretch is felt in hamstrings.',
            'Contract glutes and hamstrings to return to standing.'
          ],
          commonMistakes: ['Squatting instead of hinging.', 'Rounding spine.'],
          safetyTips: ['Keep bar close to legs throughout movement.'],
          alternativeExerciseIds: ['ex_barbell_squat'],
        ),

        // SHOULDERS
        Exercise(
          id: 'ex_overhead_press',
          name: 'Overhead Barbell Press (OHP)',
          description: 'Strict vertical press for anterior and lateral deltoid size and strength.',
          primaryMuscles: ['Shoulders'],
          secondaryMuscles: ['Triceps', 'Chest'],
          equipment: 'Barbell',
          difficulty: 'Intermediate',
          instructions: [
            'Rest bar across front deltoids with hands just outside shoulders.',
            'Brace core and glutes, press bar straight up past face.',
            'Lock out overhead with bar directly over shoulder joints.',
            'Lower slowly back to collarbone.'
          ],
          commonMistakes: ['Excessive arching of lower back.', 'Pushing bar forward instead of straight up.'],
          safetyTips: ['Do not lean backward excessively to compensate for heavy weight.'],
          alternativeExerciseIds: ['ex_db_shoulder_press', 'ex_lat_raise'],
        ),
        Exercise(
          id: 'ex_lat_raise',
          name: 'Dumbbell Lateral Raise',
          description: 'Isolation exercise targeting lateral deltoids for shoulder width.',
          primaryMuscles: ['Shoulders'],
          equipment: 'Dumbbell',
          difficulty: 'Beginner',
          instructions: [
            'Stand holding dumbbells at sides with slight bend in elbows.',
            'Raise arms outward to sides until parallel with shoulders.',
            'Pause briefly at peak contraction, then lower under control.'
          ],
          commonMistakes: ['Shrugging shoulders up using traps.', 'Swinging body for momentum.'],
          safetyTips: ['Use manageable weight for strict form.'],
          alternativeExerciseIds: ['ex_overhead_press'],
        ),

        // ARMS (BICEPS & TRICEPS)
        Exercise(
          id: 'ex_bicep_curl',
          name: 'Barbell Bicep Curl',
          description: 'Classic bicep builder targeting long and short heads of biceps.',
          primaryMuscles: ['Biceps'],
          equipment: 'Barbell',
          difficulty: 'Beginner',
          instructions: [
            'Stand tall holding bar with underhand shoulder-width grip.',
            'Keep elbows tucked by sides and curl weight toward shoulders.',
            'Squeeze biceps at top, then lower bar slowly.'
          ],
          commonMistakes: ['Swinging torso or elbows moving forward.'],
          safetyTips: ['Maintain erect posture without leaning back.'],
          alternativeExerciseIds: ['ex_db_hammer_curl'],
        ),
        Exercise(
          id: 'ex_db_hammer_curl',
          name: 'Dumbbell Hammer Curl',
          description: 'Targets brachialis and forearm strength for thicker arm appearance.',
          primaryMuscles: ['Biceps'],
          equipment: 'Dumbbell',
          difficulty: 'Beginner',
          instructions: [
            'Hold dumbbells at sides with neutral grip (palms facing each other).',
            'Curl weight up while keeping palms facing in throughout motion.',
            'Lower with control back to starting position.'
          ],
          commonMistakes: ['Using momentum to swing weights.'],
          safetyTips: ['Keep wrist joints stiff and neutral.'],
          alternativeExerciseIds: ['ex_bicep_curl'],
        ),
        Exercise(
          id: 'ex_tricep_pushdown',
          name: 'Cable Tricep Pushdown',
          description: 'High isolation tricep exercise focusing on pushdown contraction.',
          primaryMuscles: ['Triceps'],
          equipment: 'Cable',
          difficulty: 'Beginner',
          instructions: [
            'Attach bar or rope to high pulley, pin elbows to ribs.',
            'Push attachment down extending arms fully.',
            'Squeeze triceps at bottom, return to 90-degree elbow bend.'
          ],
          commonMistakes: ['Letting elbows flare out or drift forward.'],
          safetyTips: ['Control negative release.'],
          alternativeExerciseIds: ['ex_tricep_dips'],
        ),
        Exercise(
          id: 'ex_tricep_dips',
          name: 'Bodyweight Tricep Dips',
          description: 'Compound pushing bodyweight movement targeting triceps and lower chest.',
          primaryMuscles: ['Triceps'],
          secondaryMuscles: ['Chest', 'Shoulders'],
          equipment: 'Bodyweight',
          difficulty: 'Intermediate',
          instructions: [
            'Grip parallel bars and lift body until arms are straight.',
            'Lower body by bending elbows until upper arms are parallel to floor.',
            'Push back up to starting locked position.'
          ],
          commonMistakes: ['Dipping too deep putting stress on shoulders.'],
          safetyTips: ['Keep torso vertical to focus on triceps.'],
          alternativeExerciseIds: ['ex_tricep_pushdown'],
        ),

        // ABS & CORE
        Exercise(
          id: 'ex_plank',
          name: 'Core Forearm Plank',
          description: 'Isometric core stability exercise strengthening abdominal wall and lower back.',
          primaryMuscles: ['Abs'],
          equipment: 'Bodyweight',
          difficulty: 'Beginner',
          instructions: [
            'Place forearms on floor with elbows directly under shoulders.',
            'Extend legs back with toes grounded, forming straight line from head to heels.',
            'Brace core tight and hold position.'
          ],
          commonMistakes: ['Sagging hips toward floor.', 'Piking glutes in the air.'],
          safetyTips: ['Breathe steadily throughout the hold.'],
          alternativeExerciseIds: ['ex_hanging_leg_raise'],
        ),
        Exercise(
          id: 'ex_hanging_leg_raise',
          name: 'Hanging Leg Raise',
          description: 'Advanced lower abdominal builder.',
          primaryMuscles: ['Abs'],
          equipment: 'Bodyweight',
          difficulty: 'Intermediate',
          instructions: [
            'Hang from pull-up bar with arms fully extended.',
            'Flex hips and raise straight legs up until parallel with floor.',
            'Lower legs smoothly without swinging.'
          ],
          commonMistakes: ['Using swinging momentum.'],
          safetyTips: ['Bend knees slightly if hamstring flexibility is limited.'],
          alternativeExerciseIds: ['ex_plank'],
        ),
      ];
}
