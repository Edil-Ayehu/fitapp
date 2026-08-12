import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/active_workout_provider.dart';
import 'progress_ring.dart';

class RestTimerDialog extends StatelessWidget {
  const RestTimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final activeProvider = Provider.of<ActiveWorkoutProvider>(context);
    final session = activeProvider.session;

    if (session == null || !session.isRestTimerRunning) {
      return const SizedBox.shrink();
    }

    final secondsRemaining = session.activeRestSeconds;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2332),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF00E5FF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          ProgressRing(
            progress: (secondsRemaining / 90).clamp(0.0, 1.0),
            size: 60,
            strokeWidth: 6,
            ringColor: const Color(0xFF00E5FF),
            centerChild: Text(
              '${secondsRemaining}s',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '⏱️ REST TIMER',
                  style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  secondsRemaining > 0 ? 'Catch your breath...' : 'Rest complete! Set ready!',
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          // Actions
          IconButton(
            onPressed: () => activeProvider.addRestTime(15),
            icon: const Icon(Icons.add, color: Colors.white),
            tooltip: '+15s',
          ),
          TextButton(
            onPressed: () => activeProvider.skipRestTimer(),
            child: const Text('SKIP', style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
