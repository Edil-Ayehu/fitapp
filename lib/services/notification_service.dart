class NotificationSettingsState {
  bool workoutReminders;
  bool waterReminders;
  bool mealReminders;
  bool streakAlerts;
  bool trialEndAlerts;

  NotificationSettingsState({
    this.workoutReminders = true,
    this.waterReminders = true,
    this.mealReminders = true,
    this.streakAlerts = true,
    this.trialEndAlerts = true,
  });
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime time;
  final String category; // workout, water, meal, streak, subscription

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    DateTime? time,
    required this.category,
  }) : time = time ?? DateTime.now();
}

class NotificationService {
  NotificationSettingsState settings = NotificationSettingsState();

  List<AppNotification> sampleRecentNotifications = [
    AppNotification(
      id: 'notif_1',
      title: '💪 Workout Time!',
      body: 'Your Chest & Triceps workout starts in 30 minutes. Let\'s crush it!',
      category: 'workout',
    ),
    AppNotification(
      id: 'notif_2',
      title: '💧 Stay Hydrated',
      body: 'Time to drink some water. You\'re 700ml away from your daily goal!',
      category: 'water',
    ),
    AppNotification(
      id: 'notif_3',
      title: '🔥 Impressive Streak!',
      body: 'You are on a 7-day workout streak! Keep up the momentum!',
      category: 'streak',
    ),
    AppNotification(
      id: 'notif_4',
      title: '🍎 Meal Log Reminder',
      body: 'Don\'t forget to log your high protein lunch to hit your macros.',
      category: 'meal',
    ),
  ];
}
