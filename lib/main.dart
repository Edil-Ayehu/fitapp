import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'services/storage_service.dart';
import 'services/ai_coach_service.dart';

import 'providers/auth_provider.dart';
import 'providers/workout_provider.dart';
import 'providers/active_workout_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/nutrition_provider.dart';
import 'providers/health_provider.dart';
import 'providers/ai_provider.dart';
import 'providers/subscription_provider.dart';

import 'screens/splash_intro_screen.dart';
import 'screens/dashboard/home_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  final aiService = AICoachService();

  runApp(
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
}

class FitPulseApp extends StatelessWidget {
  const FitPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    final darkTextTheme = GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme);

    return MaterialApp(
      title: 'FitPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF10121A),
        primaryColor: const Color(0xFFD0FD38),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD0FD38),
          onPrimary: Colors.black,
          secondary: Color(0xFF00E5FF),
          onSecondary: Colors.black,
          surface: Color(0xFF181B26),
          onSurface: Colors.white,
          error: Colors.redAccent,
          onError: Colors.white,
        ),
        textTheme: darkTextTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF141722),
          elevation: 0,
          titleTextStyle: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF181B26),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          titleTextStyle: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          contentTextStyle: GoogleFonts.outfit(fontSize: 14, color: Colors.white70),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF1E2232),
          selectedColor: const Color(0xFFD0FD38),
          secondarySelectedColor: const Color(0xFF00E5FF),
          labelStyle: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w600),
          secondaryLabelStyle: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold),
          checkmarkColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E2232),
          hintStyle: GoogleFonts.outfit(color: Colors.white38),
          labelStyle: GoogleFonts.outfit(color: Colors.white70),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFD0FD38), width: 1.5),
          ),
        ),
      ),
      home: auth.isLoggedIn && auth.userProfile.isOnboardingCompleted
          ? const HomeDashboardScreen()
          : const SplashIntroScreen(),
    );
  }
}

