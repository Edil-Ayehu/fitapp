class UserProfile {
  String id;
  String email;
  String name;
  int age;
  String gender;
  double heightCm;
  double weightKg;
  String fitnessLevel; // Beginner, Intermediate, Advanced
  String primaryGoal; // Lose weight, Build muscle, Gain weight, Improve strength, Endurance, General fitness
  double targetWeightKg;
  int availableDays; // e.g. 3, 4, 5, 6
  int workoutDurationMinutes; // 30, 45, 60, 90
  String preferredLocation; // Gym, Home, Outdoor
  List<String> availableEquipment;
  String dietaryPreferences; // None, High Protein, Keto, Vegetarian, Vegan
  List<String> allergies;
  String workoutStyle; // Hypertrophy, Powerlifting, HIIT, Calisthenics, Mixed
  bool isOnboardingCompleted;
  bool isBiometricEnabled;
  DateTime createdAt;

  // Calculated Targets
  int targetCalories;
  int targetProteinGrams;
  int targetCarbsGrams;
  int targetFatGrams;
  double targetWaterLiters;

  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    this.age = 25,
    this.gender = 'Male',
    this.heightCm = 175,
    this.weightKg = 75,
    this.fitnessLevel = 'Intermediate',
    this.primaryGoal = 'Build muscle',
    this.targetWeightKg = 80,
    this.availableDays = 4,
    this.workoutDurationMinutes = 60,
    this.preferredLocation = 'Gym',
    this.availableEquipment = const ['Barbell', 'Dumbbell', 'Machine', 'Cable'],
    this.dietaryPreferences = 'High Protein',
    this.allergies = const [],
    this.workoutStyle = 'Hypertrophy',
    this.isOnboardingCompleted = false,
    this.isBiometricEnabled = true,
    DateTime? createdAt,
    this.targetCalories = 2400,
    this.targetProteinGrams = 170,
    this.targetCarbsGrams = 260,
    this.targetFatGrams = 70,
    this.targetWaterLiters = 3.0,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserProfile.defaultUser() {
    return UserProfile(
      id: 'usr_default',
      email: 'alex.fitness@fitpulse.app',
      name: 'Alex Johnson',
      age: 26,
      gender: 'Male',
      heightCm: 180,
      weightKg: 78.5,
      fitnessLevel: 'Intermediate',
      primaryGoal: 'Build muscle',
      targetWeightKg: 82.0,
      availableDays: 4,
      workoutDurationMinutes: 60,
      preferredLocation: 'Gym',
      availableEquipment: ['Barbell', 'Dumbbell', 'Machine', 'Cable', 'Bodyweight'],
      dietaryPreferences: 'High Protein',
      allergies: [],
      workoutStyle: 'Hypertrophy',
      isOnboardingCompleted: true,
      isBiometricEnabled: true,
      targetCalories: 2550,
      targetProteinGrams: 180,
      targetCarbsGrams: 275,
      targetFatGrams: 75,
      targetWaterLiters: 3.2,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'age': age,
        'gender': gender,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'fitnessLevel': fitnessLevel,
        'primaryGoal': primaryGoal,
        'targetWeightKg': targetWeightKg,
        'availableDays': availableDays,
        'workoutDurationMinutes': workoutDurationMinutes,
        'preferredLocation': preferredLocation,
        'availableEquipment': availableEquipment,
        'dietaryPreferences': dietaryPreferences,
        'allergies': allergies,
        'workoutStyle': workoutStyle,
        'isOnboardingCompleted': isOnboardingCompleted,
        'isBiometricEnabled': isBiometricEnabled,
        'createdAt': createdAt.toIso8601String(),
        'targetCalories': targetCalories,
        'targetProteinGrams': targetProteinGrams,
        'targetCarbsGrams': targetCarbsGrams,
        'targetFatGrams': targetFatGrams,
        'targetWaterLiters': targetWaterLiters,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] ?? 'usr_1',
        email: json['email'] ?? '',
        name: json['name'] ?? '',
        age: json['age'] ?? 25,
        gender: json['gender'] ?? 'Male',
        heightCm: (json['heightCm'] as num?)?.toDouble() ?? 175.0,
        weightKg: (json['weightKg'] as num?)?.toDouble() ?? 75.0,
        fitnessLevel: json['fitnessLevel'] ?? 'Intermediate',
        primaryGoal: json['primaryGoal'] ?? 'Build muscle',
        targetWeightKg: (json['targetWeightKg'] as num?)?.toDouble() ?? 80.0,
        availableDays: json['availableDays'] ?? 4,
        workoutDurationMinutes: json['workoutDurationMinutes'] ?? 60,
        preferredLocation: json['preferredLocation'] ?? 'Gym',
        availableEquipment: List<String>.from(json['availableEquipment'] ?? []),
        dietaryPreferences: json['dietaryPreferences'] ?? 'High Protein',
        allergies: List<String>.from(json['allergies'] ?? []),
        workoutStyle: json['workoutStyle'] ?? 'Hypertrophy',
        isOnboardingCompleted: json['isOnboardingCompleted'] ?? false,
        isBiometricEnabled: json['isBiometricEnabled'] ?? true,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        targetCalories: json['targetCalories'] ?? 2400,
        targetProteinGrams: json['targetProteinGrams'] ?? 170,
        targetCarbsGrams: json['targetCarbsGrams'] ?? 260,
        targetFatGrams: json['targetFatGrams'] ?? 70,
        targetWaterLiters: (json['targetWaterLiters'] as num?)?.toDouble() ?? 3.0,
      );

  // Recalculates personalized macro and calorie targets based on physical metrics
  void recalculatePersonalizedTargets() {
    // Simple BMR calculation (Mifflin-St Jeor equation)
    double bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + (gender == 'Male' ? 5 : -161);
    double activityMultiplier = availableDays >= 5 ? 1.55 : 1.375;
    double tdee = bmr * activityMultiplier;

    if (primaryGoal == 'Lose weight') {
      targetCalories = (tdee - 400).round();
      targetProteinGrams = (weightKg * 2.2).round(); // High protein for muscle retention
      targetFatGrams = ((targetCalories * 0.25) / 9).round();
      targetCarbsGrams = ((targetCalories - (targetProteinGrams * 4) - (targetFatGrams * 9)) / 4).round();
    } else if (primaryGoal == 'Build muscle' || primaryGoal == 'Gain weight') {
      targetCalories = (tdee + 300).round();
      targetProteinGrams = (weightKg * 2.0).round();
      targetFatGrams = ((targetCalories * 0.25) / 9).round();
      targetCarbsGrams = ((targetCalories - (targetProteinGrams * 4) - (targetFatGrams * 9)) / 4).round();
    } else {
      targetCalories = tdee.round();
      targetProteinGrams = (weightKg * 1.8).round();
      targetFatGrams = ((targetCalories * 0.25) / 9).round();
      targetCarbsGrams = ((targetCalories - (targetProteinGrams * 4) - (targetFatGrams * 9)) / 4).round();
    }

    targetWaterLiters = double.parse((weightKg * 0.038).toStringAsFixed(1));
    if (targetWaterLiters < 2.5) targetWaterLiters = 2.5;
  }
}
