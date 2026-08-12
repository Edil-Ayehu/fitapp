import 'package:flutter/material.dart';
import '../../models/exercise.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/stat_chip.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(exercise.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Graphic Banner Placeholder
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2232),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.fitness_center, color: Color(0xFFD0FD38), size: 64),
                  const SizedBox(height: 8),
                  Text('Visual Guide: ${exercise.name}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Target Muscle & Equipment Chips
            Wrap(
              spacing: 8,
              children: [
                StatChip(label: 'Primary: ${exercise.primaryMuscles.join(", ")}', color: const Color(0xFFD0FD38)),
                StatChip(label: exercise.equipment, color: const Color(0xFF00E5FF)),
                StatChip(label: exercise.difficulty, color: Colors.purpleAccent),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              exercise.description,
              style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 24),

            // Step-by-Step Instructions
            const Text('📋 Instructions', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...exercise.instructions.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: const Color(0xFFD0FD38),
                      child: Text('${entry.key + 1}', style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(entry.value, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.3)),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            // Common Mistakes
            if (exercise.commonMistakes.isNotEmpty) ...[
              GlassCard(
                borderColor: Colors.redAccent.withOpacity(0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 20),
                        SizedBox(width: 8),
                        Text('Common Mistakes to Avoid', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...exercise.commonMistakes.map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $m', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Safety Tips
            if (exercise.safetyTips.isNotEmpty) ...[
              GlassCard(
                borderColor: const Color(0xFF00E5FF).withOpacity(0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.shield_outlined, color: Color(0xFF00E5FF), size: 20),
                        SizedBox(width: 8),
                        Text('Safety Tips', style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...exercise.safetyTips.map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $s', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        )),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
