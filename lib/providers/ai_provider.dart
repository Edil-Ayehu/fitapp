import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../models/workout_program.dart';
import '../services/ai_coach_service.dart';

class AIProvider extends ChangeNotifier {
  final AICoachService _aiService;

  final List<AICoachChatMessage> _messages = [];
  bool _isGeneratingResponse = false;

  AIProvider(this._aiService) {
    _messages.add(AICoachChatMessage(
      id: 'msg_welcome',
      sender: 'ai',
      text: "👋 Hi! I'm your AI Personal Trainer. Ask me anything about your workout, nutrition, form tips, or request custom workout modifications!",
    ));
  }

  List<AICoachChatMessage> get messages => _messages;
  bool get isGeneratingResponse => _isGeneratingResponse;

  Future<void> sendMessage(String text, UserProfile user) async {
    if (text.trim().isEmpty) return;

    final userMsg = AICoachChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'user',
      text: text,
    );
    _messages.add(userMsg);
    _isGeneratingResponse = true;
    notifyListeners();

    final aiReplyText = await _aiService.getAIResponse(text, user);

    final aiMsg = AICoachChatMessage(
      id: 'msg_ai_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'ai',
      text: aiReplyText,
    );
    _messages.add(aiMsg);
    _isGeneratingResponse = false;
    notifyListeners();
  }

  Future<WorkoutRoutine> generateAIWorkout({
    required String goal,
    required int days,
    required int durationMinutes,
    required String equipment,
    required String level,
  }) async {
    _isGeneratingResponse = true;
    notifyListeners();

    final routine = await _aiService.generateAIWorkout(
      goal: goal,
      days: days,
      durationMinutes: durationMinutes,
      equipment: equipment,
      level: level,
    );

    _isGeneratingResponse = false;
    notifyListeners();
    return routine;
  }
}
