import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';

class OnboardingProvider extends ChangeNotifier {
  int _currentStep = 0;
  
  // Form fields
  String name = 'Alex';
  int age = 26;
  String gender = 'Male';
  double heightCm = 178;
  double weightKg = 78;
  String fitnessLevel = 'Intermediate';
  String primaryGoal = 'Build muscle';
  double targetWeightKg = 82;
  int availableDays = 4;
  int workoutDurationMinutes = 60;
  String preferredLocation = 'Gym';
  List<String> selectedEquipment = ['Barbell', 'Dumbbell', 'Machine', 'Cable'];
  String dietaryPreferences = 'High Protein';
  List<String> allergies = [];
  String workoutStyle = 'Hypertrophy';

  int get currentStep => _currentStep;
  int get totalSteps => 7;

  void setStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  UserProfile generateFinalProfile(String userEmail) {
    final profile = UserProfile(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: userEmail,
      name: name,
      age: age,
      gender: gender,
      heightCm: heightCm,
      weightKg: weightKg,
      fitnessLevel: fitnessLevel,
      primaryGoal: primaryGoal,
      targetWeightKg: targetWeightKg,
      availableDays: availableDays,
      workoutDurationMinutes: workoutDurationMinutes,
      preferredLocation: preferredLocation,
      availableEquipment: selectedEquipment,
      dietaryPreferences: dietaryPreferences,
      allergies: allergies,
      workoutStyle: workoutStyle,
      isOnboardingCompleted: true,
    );
    profile.recalculatePersonalizedTargets();
    return profile;
  }
}
