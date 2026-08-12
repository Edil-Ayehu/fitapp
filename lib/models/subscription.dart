enum SubscriptionPlan { free, monthly, yearly }

class SubscriptionState {
  SubscriptionPlan plan;
  bool isTrialActive;
  DateTime? trialEndDate;
  DateTime? subscriptionEndDate;
  int aiQuestionsRemainingToday; // Free users get 3 AI questions/day

  SubscriptionState({
    this.plan = SubscriptionPlan.free,
    this.isTrialActive = false,
    this.trialEndDate,
    this.subscriptionEndDate,
    this.aiQuestionsRemainingToday = 3,
  });

  bool get isPremium => plan != SubscriptionPlan.free || isTrialActive;

  Map<String, dynamic> toJson() => {
        'plan': plan.index,
        'isTrialActive': isTrialActive,
        'trialEndDate': trialEndDate?.toIso8601String(),
        'subscriptionEndDate': subscriptionEndDate?.toIso8601String(),
        'aiQuestionsRemainingToday': aiQuestionsRemainingToday,
      };

  factory SubscriptionState.fromJson(Map<String, dynamic> json) => SubscriptionState(
        plan: SubscriptionPlan.values[json['plan'] ?? 0],
        isTrialActive: json['isTrialActive'] ?? false,
        trialEndDate: json['trialEndDate'] != null ? DateTime.parse(json['trialEndDate']) : null,
        subscriptionEndDate: json['subscriptionEndDate'] != null ? DateTime.parse(json['subscriptionEndDate']) : null,
        aiQuestionsRemainingToday: json['aiQuestionsRemainingToday'] ?? 3,
      );
}
