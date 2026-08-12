import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/workout_program.dart';
import '../models/workout_log.dart';
import '../models/nutrition_log.dart';
import '../models/health_metrics.dart';
import '../models/subscription.dart';

class StorageService {
  static const String _keyUser = 'fitapp_user_profile';
  static const String _keyCustomRoutines = 'fitapp_custom_routines';
  static const String _keyWorkoutLogs = 'fitapp_workout_logs';
  static const String _keyPRs = 'fitapp_prs';
  static const String _keyMeals = 'fitapp_logged_meals';
  static const String _keyWeightLogs = 'fitapp_weight_logs';
  static const String _keyWaterMlToday = 'fitapp_water_ml_today';
  static const String _keyStepsToday = 'fitapp_steps_today';
  static const String _keySubscription = 'fitapp_subscription';
  static const String _keyStreakDays = 'fitapp_streak_days';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- USER PROFILE ---
  Future<void> saveUserProfile(UserProfile profile) async {
    await _prefs.setString(_keyUser, jsonEncode(profile.toJson()));
  }

  UserProfile getUserProfile() {
    final str = _prefs.getString(_keyUser);
    if (str != null) {
      try {
        return UserProfile.fromJson(jsonDecode(str));
      } catch (_) {}
    }
    return UserProfile.defaultUser();
  }

  // --- STREAK ---
  int getStreakDays() => _prefs.getInt(_keyStreakDays) ?? 7;
  Future<void> saveStreakDays(int days) async => await _prefs.setInt(_keyStreakDays, days);

  // --- WORKOUT ROUTINES ---
  Future<void> saveCustomRoutines(List<WorkoutRoutine> routines) async {
    final listJson = routines.map((r) => r.toJson()).toList();
    await _prefs.setString(_keyCustomRoutines, jsonEncode(listJson));
  }

  List<WorkoutRoutine> getCustomRoutines() {
    final str = _prefs.getString(_keyCustomRoutines);
    if (str != null) {
      try {
        final List raw = jsonDecode(str);
        return raw.map((r) => WorkoutRoutine.fromJson(r)).toList();
      } catch (_) {}
    }
    return WorkoutRoutine.sampleRoutines;
  }

  // --- WORKOUT LOGS & PRS ---
  Future<void> saveWorkoutLogs(List<WorkoutLogEntry> logs) async {
    final listJson = logs.map((l) => l.toJson()).toList();
    await _prefs.setString(_keyWorkoutLogs, jsonEncode(listJson));
  }

  List<WorkoutLogEntry> getWorkoutLogs() {
    final str = _prefs.getString(_keyWorkoutLogs);
    if (str != null) {
      try {
        final List raw = jsonDecode(str);
        return raw.map((l) => WorkoutLogEntry.fromJson(l)).toList();
      } catch (_) {}
    }
    return WorkoutLogEntry.sampleLogs;
  }

  Future<void> savePRs(List<PersonalRecord> prs) async {
    final listJson = prs.map((p) => p.toJson()).toList();
    await _prefs.setString(_keyPRs, jsonEncode(listJson));
  }

  List<PersonalRecord> getPRs() {
    final str = _prefs.getString(_keyPRs);
    if (str != null) {
      try {
        final List raw = jsonDecode(str);
        return raw.map((p) => PersonalRecord.fromJson(p)).toList();
      } catch (_) {}
    }
    return [
      PersonalRecord(
        id: 'pr_1',
        exerciseId: 'ex_bench_press',
        exerciseName: 'Barbell Bench Press',
        maxWeightKg: 85.0,
        reps: 6,
        dateAchieved: DateTime.now().subtract(const Duration(days: 1)),
      ),
      PersonalRecord(
        id: 'pr_2',
        exerciseId: 'ex_barbell_squat',
        exerciseName: 'Barbell Back Squat',
        maxWeightKg: 105.0,
        reps: 6,
        dateAchieved: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  // --- NUTRITION ---
  Future<void> saveLoggedMeals(List<LoggedMealEntry> meals) async {
    final listJson = meals.map((m) => m.toJson()).toList();
    await _prefs.setString(_keyMeals, jsonEncode(listJson));
  }

  List<LoggedMealEntry> getLoggedMeals() {
    final str = _prefs.getString(_keyMeals);
    if (str != null) {
      try {
        final List raw = jsonDecode(str);
        return raw.map((m) => LoggedMealEntry.fromJson(m)).toList();
      } catch (_) {}
    }
    return [
      LoggedMealEntry(
        id: 'lm_1',
        mealType: 'Breakfast',
        food: FoodItem.sampleDatabase[3], // Oatmeal
        quantity: 1.5,
      ),
      LoggedMealEntry(
        id: 'lm_2',
        mealType: 'Breakfast',
        food: FoodItem.sampleDatabase[2], // Eggs
        quantity: 1.5,
      ),
      LoggedMealEntry(
        id: 'lm_3',
        mealType: 'Lunch',
        food: FoodItem.sampleDatabase[0], // Chicken
        quantity: 2.0,
      ),
      LoggedMealEntry(
        id: 'lm_4',
        mealType: 'Lunch',
        food: FoodItem.sampleDatabase[1], // Rice
        quantity: 2.0,
      ),
    ];
  }

  // --- HEALTH & METRICS ---
  Future<void> saveWeightLogs(List<WeightLogEntry> entries) async {
    final listJson = entries.map((e) => e.toJson()).toList();
    await _prefs.setString(_keyWeightLogs, jsonEncode(listJson));
  }

  List<WeightLogEntry> getWeightLogs() {
    final str = _prefs.getString(_keyWeightLogs);
    if (str != null) {
      try {
        final List raw = jsonDecode(str);
        return raw.map((e) => WeightLogEntry.fromJson(e)).toList();
      } catch (_) {}
    }
    final now = DateTime.now();
    return [
      WeightLogEntry(id: 'w1', weightKg: 81.2, bodyFatPercentage: 18.5, date: now.subtract(const Duration(days: 90))),
      WeightLogEntry(id: 'w2', weightKg: 80.0, bodyFatPercentage: 17.8, date: now.subtract(const Duration(days: 60))),
      WeightLogEntry(id: 'w3', weightKg: 79.1, bodyFatPercentage: 17.0, date: now.subtract(const Duration(days: 30))),
      WeightLogEntry(id: 'w4', weightKg: 78.5, bodyFatPercentage: 16.4, date: now),
    ];
  }

  int getWaterMlToday() => _prefs.getInt(_keyWaterMlToday) ?? 1800;
  Future<void> saveWaterMlToday(int ml) async => await _prefs.setInt(_keyWaterMlToday, ml);

  int getStepsToday() => _prefs.getInt(_keyStepsToday) ?? 7420;
  Future<void> saveStepsToday(int steps) async => await _prefs.setInt(_keyStepsToday, steps);

  // --- SUBSCRIPTION ---
  Future<void> saveSubscription(SubscriptionState sub) async {
    await _prefs.setString(_keySubscription, jsonEncode(sub.toJson()));
  }

  SubscriptionState getSubscription() {
    final str = _prefs.getString(_keySubscription);
    if (str != null) {
      try {
        return SubscriptionState.fromJson(jsonDecode(str));
      } catch (_) {}
    }
    return SubscriptionState();
  }
}
