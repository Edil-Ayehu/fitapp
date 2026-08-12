import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitapp/main.dart';
import 'package:fitapp/services/storage_service.dart';
import 'package:fitapp/services/ai_coach_service.dart';
import 'package:fitapp/providers/auth_provider.dart';
import 'package:fitapp/providers/workout_provider.dart';
import 'package:fitapp/providers/active_workout_provider.dart';
import 'package:fitapp/providers/progress_provider.dart';
import 'package:fitapp/providers/nutrition_provider.dart';
import 'package:fitapp/providers/health_provider.dart';
import 'package:fitapp/providers/ai_provider.dart';
import 'package:fitapp/providers/subscription_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storageService = StorageService();
    await storageService.init();
    final aiService = AICoachService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider(storageService)),
          ChangeNotifierProvider(create: (_) => WorkoutProvider(storageService)),
          ChangeNotifierProvider(create: (_) => ActiveWorkoutProvider()),
          ChangeNotifierProvider(create: (_) => ProgressProvider(storageService)),
          ChangeNotifierProvider(create: (_) => NutritionProvider(storageService)),
          ChangeNotifierProvider(create: (_) => HealthProvider(storageService)),
          ChangeNotifierProvider(create: (_) => AIProvider(aiService)),
          ChangeNotifierProvider(create: (_) => SubscriptionProvider(storageService)),
        ],
        child: const FitPulseApp(),
      ),
    );

    expect(find.byType(FitPulseApp), findsOneWidget);
  });
}
